
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_GEOCODE_PKG" AS

    FUNCTION get_place_name(
        p_latitude  IN NUMBER,
        p_longitude IN NUMBER
    ) RETURN VARCHAR2
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        l_lat        NUMBER(9,4);
        l_lng        NUMBER(9,4);
        l_place      VARCHAR2(500);
        l_response   CLOB;

    BEGIN
        IF p_latitude IS NULL OR p_longitude IS NULL THEN
            RETURN NULL;
        END IF;

        l_lat := ROUND(p_latitude, 4);
        l_lng := ROUND(p_longitude, 4);

        -- Cache check
        BEGIN
            SELECT place_name INTO l_place
            FROM   ptw_pro.ptw_geocode_cache
            WHERE  latitude = l_lat
            AND    longitude = l_lng;

            RETURN l_place;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- fall through to the live lookup below
        END;

        -- Live lookup — OpenStreetMap Nominatim. User-Agent is required by
        -- Nominatim's usage policy; update the contact address if this ever
        -- moves to a different domain/team.
        --
        -- MAKE_REST_REQUEST has no header parameters of its own - custom
        -- headers must be set via SET_REQUEST_HEADERS first, which applies
        -- to whatever MAKE_REST_REQUEST call follows it. p_reset defaults
        -- to TRUE, which clears any headers left over from a previous call
        -- in this session - exactly what you want here, so a stale header
        -- from an unrelated web service call earlier in the same session
        -- can't leak into this request.
        BEGIN
            apex_web_service.set_request_headers(
                p_name_01  => 'User-Agent',
                p_value_01 => 'PTW-PRO PermitApp/1.0 (safety@yourcompany.com)'
            );

            l_response := apex_web_service.make_rest_request(
                p_url         => 'https://nominatim.openstreetmap.org/reverse'
                                  || '?format=jsonv2&lat=' || l_lat
                                  || '&lon=' || l_lng,
                p_http_method => 'GET'
            );

            SELECT jt.display_name
            INTO   l_place
            FROM   JSON_TABLE(l_response, '$'
                       COLUMNS (display_name VARCHAR2(500) PATH '$.display_name')
                   ) jt;

        EXCEPTION
            WHEN OTHERS THEN
                -- Bad coordinates, network failure, rate limit, malformed
                -- response, no display_name in the payload — all treated
                -- the same: no place name this time, nothing cached, try
                -- again on the next request rather than caching a failure.
                RETURN NULL;
        END;

        IF l_place IS NOT NULL THEN
            BEGIN
                INSERT INTO ptw_pro.ptw_geocode_cache (latitude, longitude, place_name)
                VALUES (l_lat, l_lng, l_place);
                COMMIT;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    -- Another session cached this exact rounded coordinate
                    -- pair between our SELECT and our INSERT — harmless,
                    -- our result is still correct to return either way.
                    NULL;
            END;
        END IF;

        RETURN l_place;

    END get_place_name;

END ptw_geocode_pkg;
/
