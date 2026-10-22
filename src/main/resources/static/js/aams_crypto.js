/**
 * AAMS Payload & URL Parameter Security Encryption Module
 * - Dual Engine: Web Crypto API (for Secure Contexts) + Pure JS FastAes256 (for HTTP / Remote Linux Intranet)
 * - Algorithm: AES-256-CBC + PKCS7 Padding + 16-byte random IV
 * - Format: URL-Safe Base64 (RFC 4648 without padding)
 * - Transparent Fetch Interceptor: Automatically encrypts /api/** query params and JSON bodies,
 *   and decrypts incoming {"encData": "..."} responses seamlessly for grids and forms.
 */
(function (window) {
    'use strict';

    /**
     * 1. Pure JavaScript AES-256-CBC Standalone Engine
     * Used when Web Crypto API (crypto.subtle) is unavailable (e.g. Insecure HTTP contexts on remote servers)
     */
    var FastAes256 = (function () {
        var SBOX = new Uint8Array([
            0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
            0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
            0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
            0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
            0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
            0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
            0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
            0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
            0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
            0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
            0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
            0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
            0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
            0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
            0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
            0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16
        ]);

        var INV_SBOX = new Uint8Array(256);
        for (var i = 0; i < 256; i++) {
            INV_SBOX[SBOX[i]] = i;
        }

        var RCON = new Uint32Array([
            0x00000000, 0x01000000, 0x02000000, 0x04000000, 0x08000000,
            0x10000000, 0x20000000, 0x40000000, 0x80000000, 0x1b000000, 0x36000000
        ]);

        function rotWord(w) {
            return ((w << 8) | (w >>> 24)) >>> 0;
        }

        function subWord(w) {
            return ((SBOX[(w >>> 24) & 0xff] << 24) |
                    (SBOX[(w >>> 16) & 0xff] << 16) |
                    (SBOX[(w >>> 8) & 0xff] << 8) |
                    (SBOX[w & 0xff])) >>> 0;
        }

        function expandKey(keyBytes) {
            var w = new Uint32Array(60);
            for (var i = 0; i < 8; i++) {
                w[i] = ((keyBytes[4*i] << 24) | (keyBytes[4*i+1] << 16) | (keyBytes[4*i+2] << 8) | keyBytes[4*i+3]) >>> 0;
            }
            for (var i = 8; i < 60; i++) {
                var temp = w[i - 1];
                if (i % 8 === 0) {
                    temp = (subWord(rotWord(temp)) ^ RCON[i / 8]) >>> 0;
                } else if (i % 8 === 4) {
                    temp = subWord(temp);
                }
                w[i] = (w[i - 8] ^ temp) >>> 0;
            }
            return w;
        }

        function gmul(a, b) {
            var p = 0;
            for (var i = 0; i < 8; i++) {
                if ((b & 1) !== 0) p ^= a;
                var hi = a & 0x80;
                a = (a << 1) & 0xff;
                if (hi !== 0) a ^= 0x1b;
                b >>>= 1;
            }
            return p;
        }

        function cipherBlock(input, offset, roundKeys) {
            var s = new Uint8Array(16);
            for (var i = 0; i < 16; i++) s[i] = input[offset + i];

            for (var i = 0; i < 4; i++) {
                var rk = roundKeys[i];
                s[4*i] ^= (rk >>> 24) & 0xff;
                s[4*i+1] ^= (rk >>> 16) & 0xff;
                s[4*i+2] ^= (rk >>> 8) & 0xff;
                s[4*i+3] ^= rk & 0xff;
            }

            for (var round = 1; round <= 14; round++) {
                for (var i = 0; i < 16; i++) s[i] = SBOX[s[i]];

                var t1 = s[1], t2 = s[2], t3 = s[3];
                s[1] = s[5]; s[5] = s[9]; s[9] = s[13]; s[13] = t1;
                s[2] = s[10]; s[10] = t2;
                var t6 = s[6]; s[6] = s[14]; s[14] = t6;
                s[3] = s[15]; s[15] = s[11]; s[11] = s[7]; s[7] = t3;

                if (round < 14) {
                    for (var c = 0; c < 4; c++) {
                        var idx = 4 * c;
                        var a0 = s[idx], a1 = s[idx+1], a2 = s[idx+2], a3 = s[idx+3];
                        s[idx]   = gmul(0x02, a0) ^ gmul(0x03, a1) ^ a2 ^ a3;
                        s[idx+1] = a0 ^ gmul(0x02, a1) ^ gmul(0x03, a2) ^ a3;
                        s[idx+2] = a0 ^ a1 ^ gmul(0x02, a2) ^ gmul(0x03, a3);
                        s[idx+3] = gmul(0x03, a0) ^ a1 ^ a2 ^ gmul(0x02, a3);
                    }
                }

                var rkOffset = 4 * round;
                for (var i = 0; i < 4; i++) {
                    var rk = roundKeys[rkOffset + i];
                    s[4*i] ^= (rk >>> 24) & 0xff;
                    s[4*i+1] ^= (rk >>> 16) & 0xff;
                    s[4*i+2] ^= (rk >>> 8) & 0xff;
                    s[4*i+3] ^= rk & 0xff;
                }
            }
            return s;
        }

        function invCipherBlock(input, offset, roundKeys) {
            var s = new Uint8Array(16);
            for (var i = 0; i < 16; i++) s[i] = input[offset + i];

            for (var i = 0; i < 4; i++) {
                var rk = roundKeys[56 + i];
                s[4*i] ^= (rk >>> 24) & 0xff;
                s[4*i+1] ^= (rk >>> 16) & 0xff;
                s[4*i+2] ^= (rk >>> 8) & 0xff;
                s[4*i+3] ^= rk & 0xff;
            }

            for (var round = 13; round >= 0; round--) {
                var t1 = s[13], t2 = s[10], t3 = s[7];
                s[13] = s[9]; s[9] = s[5]; s[5] = s[1]; s[1] = t1;
                s[10] = s[2]; s[2] = t2;
                var t6 = s[14]; s[14] = s[6]; s[6] = t6;
                s[7] = s[11]; s[11] = s[15]; s[15] = s[3]; s[3] = t3;

                for (var i = 0; i < 16; i++) s[i] = INV_SBOX[s[i]];

                var rkOffset = 4 * round;
                for (var i = 0; i < 4; i++) {
                    var rk = roundKeys[rkOffset + i];
                    s[4*i] ^= (rk >>> 24) & 0xff;
                    s[4*i+1] ^= (rk >>> 16) & 0xff;
                    s[4*i+2] ^= (rk >>> 8) & 0xff;
                    s[4*i+3] ^= rk & 0xff;
                }

                if (round > 0) {
                    for (var c = 0; c < 4; c++) {
                        var idx = 4 * c;
                        var a0 = s[idx], a1 = s[idx+1], a2 = s[idx+2], a3 = s[idx+3];
                        s[idx]   = gmul(0x0e, a0) ^ gmul(0x0b, a1) ^ gmul(0x0d, a2) ^ gmul(0x09, a3);
                        s[idx+1] = gmul(0x09, a0) ^ gmul(0x0e, a1) ^ gmul(0x0b, a2) ^ gmul(0x0d, a3);
                        s[idx+2] = gmul(0x0d, a0) ^ gmul(0x09, a1) ^ gmul(0x0e, a2) ^ gmul(0x0b, a3);
                        s[idx+3] = gmul(0x0b, a0) ^ gmul(0x0d, a1) ^ gmul(0x09, a2) ^ gmul(0x0e, a3);
                    }
                }
            }
            return s;
        }

        return {
            encryptCbc: function (plaintextBytes, keyBytes, ivBytes) {
                var padLen = 16 - (plaintextBytes.length % 16);
                var padded = new Uint8Array(plaintextBytes.length + padLen);
                padded.set(plaintextBytes, 0);
                for (var i = plaintextBytes.length; i < padded.length; i++) padded[i] = padLen;

                var roundKeys = expandKey(keyBytes);
                var result = new Uint8Array(padded.length);
                var prevBlock = new Uint8Array(ivBytes);

                for (var offset = 0; offset < padded.length; offset += 16) {
                    var block = new Uint8Array(16);
                    for (var i = 0; i < 16; i++) block[i] = padded[offset + i] ^ prevBlock[i];
                    var enc = cipherBlock(block, 0, roundKeys);
                    result.set(enc, offset);
                    prevBlock.set(enc, 0);
                }
                return result;
            },

            decryptCbc: function (ciphertextBytes, keyBytes, ivBytes) {
                if (ciphertextBytes.length % 16 !== 0) throw new Error("Invalid ciphertext length");
                var roundKeys = expandKey(keyBytes);
                var result = new Uint8Array(ciphertextBytes.length);
                var prevBlock = new Uint8Array(ivBytes);

                for (var offset = 0; offset < ciphertextBytes.length; offset += 16) {
                    var dec = invCipherBlock(ciphertextBytes, offset, roundKeys);
                    var block = new Uint8Array(16);
                    for (var i = 0; i < 16; i++) block[i] = dec[i] ^ prevBlock[i];
                    result.set(block, offset);
                    prevBlock.set(ciphertextBytes.subarray(offset, offset + 16), 0);
                }

                var padLen = result[result.length - 1];
                if (padLen < 1 || padLen > 16) throw new Error("Invalid PKCS7 padding: " + padLen);
                for (var i = result.length - padLen; i < result.length; i++) {
                    if (result[i] !== padLen) throw new Error("Corrupted padding");
                }
                return result.subarray(0, result.length - padLen);
            }
        };
    })();

    /**
     * 2. AamsCrypto Main Facade
     */
    var AamsCrypto = {
        _enabled: false,
        _secretKey: 'AAMS_2026_SECURE_PAYLOAD_KEY_32!',
        _key32Bytes: null,
        _cryptoKey: null,
        _isInitialized: false,
        _hasSubtle: false,

        /**
         * 초기 설정 및 키 로드
         */
        init: function (config) {
            config = config || {};
            this._enabled = !!config.enabled;
            if (config.key && typeof config.key === 'string' && config.key.trim() !== '') {
                this._secretKey = config.key.trim();
            }

            // 32바이트 키 바이트 배열 생성
            this._key32Bytes = this._normalizeKeyBytes(this._secretKey);

            // Web Crypto API subtle 지원 여부 검사 (HTTPS/localhost 여부)
            this._hasSubtle = !!(window.crypto && (window.crypto.subtle || window.crypto.webkitSubtle));

            this._installFetchInterceptor();

            if (!this._enabled) {
                // 비활성 상태라도 혹시 서버 설정 동기화가 필요한 경우 비동기 체크
                this._checkServerConfig();
                this._isInitialized = true;
                return Promise.resolve(false);
            }

            var self = this;
            if (this._hasSubtle) {
                return this._importWebCryptoKey()
                    .then(function () {
                        self._isInitialized = true;
                        console.log('[AamsCrypto] End-to-End Encryption ACTIVATED via Web Crypto API.');
                        return true;
                    })
                    .catch(function (err) {
                        console.warn('[AamsCrypto] Web Crypto init failed, falling back to Pure JS AES:', err);
                        self._hasSubtle = false;
                        self._isInitialized = true;
                        console.log('[AamsCrypto] End-to-End Encryption ACTIVATED via Pure JS FastAes256.');
                        return true;
                    });
            } else {
                this._isInitialized = true;
                console.log('[AamsCrypto] End-to-End Encryption ACTIVATED via Pure JS FastAes256 (Insecure/HTTP Context).');
                return Promise.resolve(true);
            }
        },

        isEnabled: function () {
            return this._enabled;
        },

        /**
         * 서버 보안 설정 동기화 확인 (/api/common/security-config)
         */
        _checkServerConfig: function () {
            var self = this;
            try {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', '/api/common/security-config', true);
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            if (data && data.encryptionEnabled) {
                                self._enabled = true;
                                if (data.encryptionKey) self._secretKey = data.encryptionKey;
                                self._key32Bytes = self._normalizeKeyBytes(self._secretKey);
                                console.log('[AamsCrypto] Synchronized encryption: ACTIVE (Reason: ' + data.reason + ', OS: ' + data.os + ')');
                            }
                        } catch (e) {}
                    }
                };
                xhr.send();
            } catch (e) {}
        },

        /**
         * 32바이트 키 정규화
         */
        _normalizeKeyBytes: function (keyStr) {
            var encoder = (typeof TextEncoder !== 'undefined') ? new TextEncoder() : null;
            var raw = encoder ? encoder.encode(keyStr) : this._stringToUtf8Bytes(keyStr);
            var key32 = new Uint8Array(32);
            for (var i = 0; i < 32; i++) {
                key32[i] = (i < raw.length) ? raw[i] : 35; // '#'
            }
            return key32;
        },

        _importWebCryptoKey: function () {
            var subtle = window.crypto && (window.crypto.subtle || window.crypto.webkitSubtle);
            if (!subtle) return Promise.reject(new Error("No crypto.subtle"));
            var self = this;
            return subtle.importKey(
                'raw',
                this._key32Bytes,
                { name: 'AES-CBC' },
                false,
                ['encrypt', 'decrypt']
            ).then(function (key) {
                self._cryptoKey = key;
                return key;
            });
        },

        /**
         * 무작위 16바이트 IV 생성
         */
        _generateRandomIv: function () {
            var iv = new Uint8Array(16);
            if (window.crypto && typeof window.crypto.getRandomValues === 'function') {
                window.crypto.getRandomValues(iv);
            } else {
                for (var i = 0; i < 16; i++) {
                    iv[i] = Math.floor(Math.random() * 256);
                }
            }
            return iv;
        },

        /**
         * 평문 문자열을 AES-256-CBC 암호화 (IV + Ciphertext -> Base64Url)
         */
        encrypt: function (plainText) {
            if (!this._enabled || !plainText) {
                return Promise.resolve(plainText);
            }

            var self = this;
            var dataBytes = this._stringToUtf8Bytes(plainText);
            var iv = this._generateRandomIv();

            // Web Crypto API 사용 가능한 경우
            if (this._hasSubtle && this._cryptoKey) {
                var subtle = window.crypto.subtle || window.crypto.webkitSubtle;
                return subtle.encrypt(
                    { name: 'AES-CBC', iv: iv },
                    this._cryptoKey,
                    dataBytes
                ).then(function (encryptedBuffer) {
                    var encBytes = new Uint8Array(encryptedBuffer);
                    var combined = new Uint8Array(16 + encBytes.length);
                    combined.set(iv, 0);
                    combined.set(encBytes, 16);
                    return self._bytesToBase64Url(combined);
                }).catch(function (err) {
                    // 폴백: Pure JS
                    return self._encryptPureJs(dataBytes, iv);
                });
            }

            // Pure JS FastAes256 사용 (비-보안 컨텍스트 또는 fallback)
            try {
                return Promise.resolve(this._encryptPureJs(dataBytes, iv));
            } catch (err) {
                console.error('[AamsCrypto] Encryption error:', err);
                return Promise.resolve(plainText);
            }
        },

        _encryptPureJs: function (dataBytes, iv) {
            var encBytes = FastAes256.encryptCbc(dataBytes, this._key32Bytes, iv);
            var combined = new Uint8Array(16 + encBytes.length);
            combined.set(iv, 0);
            combined.set(encBytes, 16);
            return this._bytesToBase64Url(combined);
        },

        /**
         * Base64Url 암호문을 AES-256-CBC 복호화
         */
        decrypt: function (cipherText) {
            if (!this._enabled || !cipherText || typeof cipherText !== 'string') {
                return Promise.resolve(cipherText);
            }

            var self = this;
            var combined;
            try {
                combined = this._base64UrlToBytes(cipherText.trim());
                if (combined.length <= 16) {
                    return Promise.resolve(cipherText);
                }
            } catch (e) {
                return Promise.resolve(cipherText);
            }

            var iv = combined.slice(0, 16);
            var ciphertext = combined.slice(16);

            // Web Crypto API 사용 가능한 경우
            if (this._hasSubtle && this._cryptoKey) {
                var subtle = window.crypto.subtle || window.crypto.webkitSubtle;
                return subtle.decrypt(
                    { name: 'AES-CBC', iv: iv },
                    this._cryptoKey,
                    ciphertext
                ).then(function (decryptedBuffer) {
                    return self._utf8BytesToString(new Uint8Array(decryptedBuffer));
                }).catch(function (err) {
                    // 폴백: Pure JS
                    return Promise.resolve(self._decryptPureJs(ciphertext, iv, cipherText));
                });
            }

            // Pure JS FastAes256 사용
            try {
                return Promise.resolve(this._decryptPureJs(ciphertext, iv, cipherText));
            } catch (err) {
                console.warn('[AamsCrypto] Pure JS Decrypt failed:', err);
                return Promise.resolve(cipherText);
            }
        },

        _decryptPureJs: function (ciphertext, iv, originalText) {
            try {
                var decBytes = FastAes256.decryptCbc(ciphertext, this._key32Bytes, iv);
                return this._utf8BytesToString(decBytes);
            } catch (e) {
                console.warn('[AamsCrypto] Pure JS Decrypt error:', e);
                return originalText;
            }
        },

        _stringToUtf8Bytes: function (str) {
            if (typeof TextEncoder !== 'undefined') {
                return new TextEncoder().encode(str);
            }
            var utf8 = unescape(encodeURIComponent(str));
            var arr = new Uint8Array(utf8.length);
            for (var i = 0; i < utf8.length; i++) {
                arr[i] = utf8.charCodeAt(i);
            }
            return arr;
        },

        _utf8BytesToString: function (bytes) {
            if (typeof TextDecoder !== 'undefined') {
                return new TextDecoder('utf-8').decode(bytes);
            }
            var binary = '';
            for (var i = 0; i < bytes.length; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return decodeURIComponent(escape(binary));
        },

        _bytesToBase64Url: function (bytes) {
            var binary = '';
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return window.btoa(binary)
                .replace(/\+/g, '-')
                .replace(/\//g, '_')
                .replace(/=+$/, '');
        },

        _base64UrlToBytes: function (base64Url) {
            var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            while (base64.length % 4 !== 0) {
                base64 += '=';
            }
            var binary = window.atob(base64);
            var len = binary.length;
            var bytes = new Uint8Array(len);
            for (var i = 0; i < len; i++) {
                bytes[i] = binary.charCodeAt(i);
            }
            return bytes;
        },

        /**
         * 전역 fetch() 투명 가로채기 (인터셉터)
         */
        _installFetchInterceptor: function () {
            if (window._aamsFetchIntercepted) return;
            window._aamsFetchIntercepted = true;

            var originalFetch = window.fetch;

            window.fetch = async function (resource, init) {
                init = init || {};

                // AJAX/Fetch 요청 식별 헤더 주입 (주소창 직접 호출 차단 인터셉터와 연동)
                if (init.headers instanceof Headers) {
                    if (!init.headers.has('X-Requested-With')) {
                        init.headers.set('X-Requested-With', 'XMLHttpRequest');
                    }
                } else if (Array.isArray(init.headers)) {
                    var hasXrw = init.headers.some(function (h) { return h[0].toLowerCase() === 'x-requested-with'; });
                    if (!hasXrw) {
                        init.headers.push(['X-Requested-With', 'XMLHttpRequest']);
                    }
                } else {
                    init.headers = init.headers || {};
                    if (!init.headers['X-Requested-With'] && !init.headers['x-requested-with']) {
                        init.headers['X-Requested-With'] = 'XMLHttpRequest';
                    }
                }

                // 암호화 비활성화 시 원본 fetch 수행
                if (!AamsCrypto._enabled) {
                    return originalFetch.call(this, resource, init);
                }

                var url = (typeof resource === 'string') ? resource : (resource && resource.url ? resource.url : '');

                // REST API (/api/**) 대상만 암호화 파이프라인 적용
                if (url && url.indexOf('/api/') !== -1 && url.indexOf('/api/common/security-config') === -1) {
                    try {
                        // 1. URL 쿼리 파라미터 암호화 (?corpGr=2402 -> ?_enc=...)
                        var qIdx = url.indexOf('?');
                        if (qIdx !== -1) {
                            var baseUrl = url.substring(0, qIdx);
                            var queryString = url.substring(qIdx + 1);

                            if (queryString && !queryString.startsWith('_enc=')) {
                                var encQuery = await AamsCrypto.encrypt(queryString);
                                url = baseUrl + '?_enc=' + encodeURIComponent(encQuery);
                                if (typeof resource === 'string') {
                                    resource = url;
                                } else if (resource && resource.url) {
                                    try {
                                        resource = new Request(url, resource);
                                    } catch (reqErr) {
                                        resource = url;
                                    }
                                }
                            }
                        }

                        // 2. POST/PUT Body JSON 암호화 ({"encData": "..."})
                        if (init.body && typeof init.body === 'string') {
                            var trimmed = init.body.trim();
                            if ((trimmed.startsWith('{') || trimmed.startsWith('[')) && trimmed.indexOf('"encData"') === -1) {
                                var encBody = await AamsCrypto.encrypt(trimmed);
                                init.body = JSON.stringify({ encData: encBody });

                                if (init.headers instanceof Headers) {
                                    init.headers.set('Content-Type', 'application/json');
                                } else if (Array.isArray(init.headers)) {
                                    init.headers.push(['Content-Type', 'application/json']);
                                } else {
                                    init.headers['Content-Type'] = 'application/json';
                                }
                            }
                        }
                    } catch (reqEncErr) {
                        console.error('[AamsCrypto] Request encryption error:', reqEncErr);
                    }
                }

                // 원본 fetch 실행
                var response = await originalFetch.call(this, resource, init);

                // 3. Response 본문 자동 복호화 (X-AAMS-Encrypted 헤더 또는 encData 감지)
                var origJson = response.json.bind(response);
                var origText = response.text.bind(response);

                response.json = async function () {
                    var data = await origJson();
                    if (data && typeof data === 'object' && typeof data.encData === 'string') {
                        var decStr = await AamsCrypto.decrypt(data.encData);
                        try {
                            return JSON.parse(decStr);
                        } catch (parseErr) {
                            return decStr;
                        }
                    }
                    return data;
                };

                response.text = async function () {
                    var text = await origText();
                    try {
                        var parsed = JSON.parse(text);
                        if (parsed && typeof parsed.encData === 'string') {
                            return await AamsCrypto.decrypt(parsed.encData);
                        }
                    } catch (e) {}
                    return text;
                };

                return response;
            };
        }
    };

    window.AamsCrypto = AamsCrypto;

    // 스크립트 로드 즉시 인터셉터 기본 설치
    if (typeof window !== 'undefined') {
        AamsCrypto._installFetchInterceptor();
    }
})(window);
