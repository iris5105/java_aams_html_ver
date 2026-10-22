/**
 * AAMS Payload & URL Parameter Security Encryption Module (Web Crypto API based)
 * - Algorithm: AES-256-CBC + PKCS7 Padding + 16-byte random IV
 * - Format: URL-Safe Base64 (RFC 4648)
 * - Transparent Fetch Interceptor: Automatically encrypts /api/** query params and JSON bodies,
 *   and decrypts incoming {"encData": "..."} responses.
 */
(function (window) {
    'use strict';

    var AamsCrypto = {
        _enabled: false,
        _secretKey: 'AAMS_2026_SECURE_PAYLOAD_KEY_32!',
        _cryptoKey: null,
        _isInitialized: false,

        /**
         * 초기 설정 및 키 로드
         */
        init: function (config) {
            config = config || {};
            this._enabled = !!config.enabled;
            if (config.key && typeof config.key === 'string' && config.key.trim() !== '') {
                this._secretKey = config.key.trim();
            }

            if (!this._enabled) {
                this._isInitialized = true;
                return Promise.resolve(false);
            }

            return this._importKey()
                .then(function () {
                    AamsCrypto._isInitialized = true;
                    AamsCrypto._installFetchInterceptor();
                    console.log('[AamsCrypto] End-to-End Payload & URL encryption activated.');
                    return true;
                })
                .catch(function (err) {
                    console.error('[AamsCrypto] Initialization error:', err);
                    AamsCrypto._enabled = false;
                    return false;
                });
        },

        isEnabled: function () {
            return this._enabled;
        },

        /**
         * 32바이트 AES Key Import (Web Crypto API)
         */
        _importKey: function () {
            var rawKey = this._secretKey;
            var encoder = new TextEncoder();
            var keyBytes = encoder.encode(rawKey);

            var key32 = new Uint8Array(32);
            for (var i = 0; i < 32; i++) {
                key32[i] = (i < keyBytes.length) ? keyBytes[i] : 35; // '#' padding
            }

            return window.crypto.subtle.importKey(
                'raw',
                key32,
                { name: 'AES-CBC' },
                false,
                ['encrypt', 'decrypt']
            ).then(function (key) {
                AamsCrypto._cryptoKey = key;
                return key;
            });
        },

        /**
         * 평문 문자열을 AES-256-CBC 암호화 (IV + Ciphertext -> Base64Url)
         */
        encrypt: function (plainText) {
            if (!this._enabled || !plainText) {
                return Promise.resolve(plainText);
            }

            var self = this;
            var ensureKey = this._cryptoKey ? Promise.resolve(this._cryptoKey) : this._importKey();

            return ensureKey.then(function (key) {
                var iv = window.crypto.getRandomValues(new Uint8Array(16));
                var encoder = new TextEncoder();
                var dataBytes = encoder.encode(plainText);

                return window.crypto.subtle.encrypt(
                    { name: 'AES-CBC', iv: iv },
                    key,
                    dataBytes
                ).then(function (encryptedBuffer) {
                    var encryptedBytes = new Uint8Array(encryptedBuffer);
                    // 결합: [IV (16 bytes)] + [Ciphertext]
                    var combined = new Uint8Array(iv.length + encryptedBytes.length);
                    combined.set(iv, 0);
                    combined.set(encryptedBytes, iv.length);

                    return self._bytesToBase64Url(combined);
                });
            });
        },

        /**
         * Base64Url 암호문을 AES-256-CBC 복호화
         */
        decrypt: function (cipherText) {
            if (!this._enabled || !cipherText || typeof cipherText !== 'string') {
                return Promise.resolve(cipherText);
            }

            var self = this;
            var ensureKey = this._cryptoKey ? Promise.resolve(this._cryptoKey) : this._importKey();

            return ensureKey.then(function (key) {
                try {
                    var combined = self._base64UrlToBytes(cipherText.trim());
                    if (combined.length <= 16) {
                        return cipherText;
                    }

                    var iv = combined.slice(0, 16);
                    var ciphertext = combined.slice(16);

                    return window.crypto.subtle.decrypt(
                        { name: 'AES-CBC', iv: iv },
                        key,
                        ciphertext
                    ).then(function (decryptedBuffer) {
                        var decoder = new TextDecoder('utf-8');
                        return decoder.decode(decryptedBuffer);
                    }).catch(function (err) {
                        console.warn('[AamsCrypto] Decrypt failed, returning raw:', err);
                        return cipherText;
                    });
                } catch (e) {
                    console.warn('[AamsCrypto] Base64 decode failed:', e);
                    return cipherText;
                }
            });
        },

        /**
         * Base64 URL-Safe 인코딩
         */
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

        /**
         * Base64 URL-Safe 디코딩
         */
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
         * 전역 fetch() 투명 인터셉터 설치
         */
        _installFetchInterceptor: function () {
            if (window._aamsFetchIntercepted) return;
            window._aamsFetchIntercepted = true;

            var originalFetch = window.fetch;

            window.fetch = async function (resource, init) {
                // 암호화 비활성화 시 원본 fetch 수행
                if (!AamsCrypto._enabled) {
                    return originalFetch.apply(this, arguments);
                }

                init = init || {};
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
                                }
                            }
                        }

                        // 2. POST/PUT Body JSON 암호화 ({"encData": "..."})
                        if (init.body && typeof init.body === 'string') {
                            var trimmed = init.body.trim();
                            if ((trimmed.startsWith('{') || trimmed.startsWith('[')) && trimmed.indexOf('"encData"') === -1) {
                                var encBody = await AamsCrypto.encrypt(trimmed);
                                init.body = JSON.stringify({ encData: encBody });

                                init.headers = init.headers || {};
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
                var isEncHeader = response.headers && (response.headers.get('X-AAMS-Encrypted') === 'true');

                // json / text 파싱 가로채기
                var origJson = response.json.bind(response);
                var origText = response.text.bind(response);

                response.json = async function () {
                    var data = await origJson();
                    if (data && typeof data === 'object' && typeof data.encData === 'string') {
                        var decStr = await AamsCrypto.decrypt(data.encData);
                        try {
                            return JSON.parse(decStr);
                        } catch (pErr) {
                            return decStr;
                        }
                    }
                    return data;
                };

                response.text = async function () {
                    var txt = await origText();
                    if (isEncHeader || (txt && txt.indexOf('"encData"') !== -1)) {
                        try {
                            var parsed = JSON.parse(txt);
                            if (parsed && typeof parsed.encData === 'string') {
                                return await AamsCrypto.decrypt(parsed.encData);
                            }
                        } catch (e) {}
                    }
                    return txt;
                };

                return response;
            };
        }
    };

    window.AamsCrypto = AamsCrypto;

})(window);
