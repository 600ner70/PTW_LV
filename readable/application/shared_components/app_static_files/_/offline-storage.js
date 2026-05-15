// Offline Storage for APEX - IndexedDB implementation
var OfflineStorage = {
    dbName: 'APEX_OFFLINE_DB',
    storeName: 'formData',

    initDB: function() {
        return new Promise((resolve, reject) => {
            const request = indexedDB.open(this.dbName, 1);
            request.onerror = () => reject(request.error);
            request.onsuccess = () => resolve(request.result);
            request.onupgradeneeded = (event) => {
                const db = event.target.result;
                if (!db.objectStoreNames.contains(this.storeName)) {
                    const objectStore = db.createObjectStore(this.storeName, {
                        keyPath: 'id',
                        autoIncrement: true
                    });
                    objectStore.createIndex('timestamp', 'timestamp', { unique: false });
                    objectStore.createIndex('synced', 'synced', { unique: false });
                }
            };
        });
    },

    saveFormData: async function(pageId, formData, recordId) {
        const db = await this.initDB();
        const transaction = db.transaction([this.storeName], 'readwrite');
        const store = transaction.objectStore(this.storeName);
        const record = {
            pageId: pageId,
            timestamp: new Date().toISOString(),
            synced: false,
            recordId: recordId || null,
            data: formData
        };
        return new Promise((resolve, reject) => {
            const request = store.add(record);
            request.onsuccess = () => {
                console.log('Data saved offline:', request.result);
                resolve(request.result);
            };
            request.onerror = () => reject(request.error);
        });
    },

    getUnsyncedRecords: async function() {
        const db = await this.initDB();
        const transaction = db.transaction([this.storeName], 'readonly');
        const store = transaction.objectStore(this.storeName);
        return new Promise((resolve, reject) => {
            const request = store.getAll();
            request.onsuccess = () => {
                const unsyncedRecords = request.result.filter(r => r.synced === false);
                resolve(unsyncedRecords);
            };
            request.onerror = () => reject(request.error);
        });
    },

    markAsSynced: async function(id) {
        const db = await this.initDB();
        const transaction = db.transaction([this.storeName], 'readwrite');
        const store = transaction.objectStore(this.storeName);
        return new Promise((resolve, reject) => {
            const getRequest = store.get(id);
            getRequest.onsuccess = () => {
                const record = getRequest.result;
                record.synced = true;
                const updateRequest = store.put(record);
                updateRequest.onsuccess = () => resolve();
                updateRequest.onerror = () => reject(updateRequest.error);
            };
            getRequest.onerror = () => reject(getRequest.error);
        });
    },

    clearSyncedRecords: async function() {
        const db = await this.initDB();
        const transaction = db.transaction([this.storeName], 'readwrite');
        const store = transaction.objectStore(this.storeName);
        const index = store.index('synced');
        return new Promise((resolve, reject) => {
            const request = index.openCursor(true);
            request.onsuccess = (event) => {
                const cursor = event.target.result;
                if (cursor) {
                    cursor.delete();
                    cursor.continue();
                } else {
                    resolve();
                }
            };
            request.onerror = () => reject(request.error);
        });
    }
};

// Connection status management
var ConnectionManager = {
    isOnline: navigator.onLine,

    init: function() {
        var self = this;

        window.addEventListener('online', function() {
            self.isOnline = true;
            self.showStatus('online');
            self.syncData();
        });

        window.addEventListener('offline', function() {
            self.isOnline = false;
            self.showStatus('offline');
        });

        // Only show status on initial load if actually offline
        // AND only if apex is available (i.e. NOT on the login page)
        if (!self.isOnline) {
            self.showStatus('offline');
        }
    },

    showStatus: function(status) {
        // Guard: only proceed if apex and apex.message are available
        // This prevents errors on the login page where apex may not be fully loaded
        if (typeof apex === 'undefined' || typeof apex.message === 'undefined') {
            console.log('ConnectionManager: apex.message not available, skipping showStatus');
            return;
        }
        if (status === 'offline') {
            apex.message.showErrors([{
                type: 'error',
                message: '\u26a0 Offline - Your data will be saved locally',
                unsafe: false
            }]);
        } else if (status === 'online') {
            // Clear offline error when back online
            apex.message.clearErrors();
        }
    },

    syncData: async function() {
        if (!this.isOnline) return;
        if (typeof apex === 'undefined' || typeof apex.message === 'undefined') return;

        try {
            const records = await OfflineStorage.getUnsyncedRecords();
            if (records.length === 0) {
                console.log('No records to sync');
                return;
            }
            apex.message.showPageSuccess('Syncing ' + records.length + ' record(s)...');
            for (const record of records) {
                await this.syncRecord(record);
            }
            apex.message.showPageSuccess('All data synced successfully!');
        } catch (error) {
            console.error('Sync error:', error);
            if (typeof apex !== 'undefined' && typeof apex.message !== 'undefined') {
                apex.message.showErrors([{
                    type: 'error',
                    message: 'Error syncing data: ' + error.message
                }]);
            }
        }
    },

    syncRecord: async function(record) {
        return new Promise((resolve, reject) => {
            apex.server.process('SYNC_OFFLINE_DATA', {
                x01: JSON.stringify(record.data),
                x02: record.pageId,
                x03: record.recordId
            }, {
                success: async function(data) {
                    if (data.success) {
                        await OfflineStorage.markAsSynced(record.id);
                        resolve();
                    } else {
                        reject(new Error(data.message || 'Sync failed'));
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    reject(new Error(errorThrown));
                }
            });
        });
    }
};

console.log('OfflineStorage and ConnectionManager loaded');
