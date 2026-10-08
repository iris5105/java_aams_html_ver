/**
 * ============================================================================
 * AAMS Crownix MRD Report Viewer & Export Module (aams_report.js)
 * ----------------------------------------------------------------------------
 * 파워빌더 u_rd.sru 표준 규격 (ii_zoomRatio = 120%) 및 5종 포맷 내보내기,
 * 모바일 모달 팝업, MDI 탭 반응형 자동 감지 및 스마트 리사이즈 통합 모듈
 * ============================================================================
 */
(function(window) {
    'use strict';

    var AamsReport = {
        DEFAULT_ZOOM: 120,

        /**
         * 가변 파라미터 기반 범용 RD 리포트 미리보기 URL 생성
         * @param {string} mrdName - 대상 MRD 파일명 (예: "rd_ja010q.mrd")
         * @param {Object} [params] - 가변 Key-Value 파라미터 객체 { fund_cd: '...', ymd: '...' }
         * @param {Object} [options] - 옵션 { corpGr, downloadName, zoom, timestamp: true }
         * @returns {string} 완성된 미리보기 URL (120% 줌 해시 포함)
         */
        buildPreviewUrl: function(mrdName, params, options) {
            options = options || {};
            var qs = ['mrdName=' + encodeURIComponent(mrdName)];
            if (options.corpGr) qs.push('corpGr=' + encodeURIComponent(options.corpGr));
            if (options.downloadName) qs.push('downloadName=' + encodeURIComponent(options.downloadName));
            if (options.timestamp !== false) qs.push('t=' + new Date().getTime());

            if (params && typeof params === 'object') {
                for (var k in params) {
                    if (params.hasOwnProperty(k) && params[k] !== undefined && params[k] !== null) {
                        qs.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
                    }
                }
            }

            var rawUrl = '/api/common/rd/preview?' + qs.join('&');
            return this.formatPreviewUrl(rawUrl, options.zoom);
        },

        /**
         * 가변 파라미터 기반 범용 RD 리포트 파일 내보내기/다운로드 URL 생성
         * @param {string} mrdName - 대상 MRD 파일명 (예: "rd_ja010q.mrd")
         * @param {Object} [params] - 가변 Key-Value 파라미터 객체
         * @param {string} [format] - 포맷 (pdf, excel/xlsx, word/doc, ppt/pptx, hwp)
         * @param {Object} [options] - 옵션 { corpGr, downloadName }
         * @returns {string} 완성된 다운로드 URL
         */
        buildExportUrl: function(mrdName, params, format, options) {
            options = options || {};
            var qs = ['mrdName=' + encodeURIComponent(mrdName)];
            qs.push('format=' + encodeURIComponent(format || 'pdf'));
            if (options.corpGr) qs.push('corpGr=' + encodeURIComponent(options.corpGr));
            if (options.downloadName) qs.push('downloadName=' + encodeURIComponent(options.downloadName));
            qs.push('t=' + new Date().getTime());

            if (params && typeof params === 'object') {
                for (var k in params) {
                    if (params.hasOwnProperty(k) && params[k] !== undefined && params[k] !== null) {
                        qs.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
                    }
                }
            }

            return '/api/common/rd/export?' + qs.join('&');
        },

        /**
         * 리포트 미리보기 URL에 표준 PDF 파라미터(기본 zoom=120, toolbar, navpanes)를 부착
         * @param {string} url - 원본 리포트 URL
         * @param {number|string} [zoom] - 지정 확대 배율 (기본값: DEFAULT_ZOOM = 120)
         * @returns {string} 해시 파라미터가 포함된 최종 뷰어 URL
         */
        formatPreviewUrl: function(url, zoom) {
            if (!url || url === 'about:blank') return url || '';
            var cleanUrl = url.split('#')[0];
            if (zoom === 'fit' || zoom === 'page-fit' || zoom === 'Fit') {
                return cleanUrl + '#toolbar=1&navpanes=0&view=Fit';
            }
            if (zoom === 'width' || zoom === 'page-width' || zoom === 'FitH') {
                return cleanUrl + '#toolbar=1&navpanes=0&view=FitH';
            }
            var targetZoom = (zoom !== undefined && zoom !== null) ? zoom : this.DEFAULT_ZOOM;
            return cleanUrl + '#toolbar=1&navpanes=0&zoom=' + encodeURIComponent(targetZoom);
        },

        /**
         * 현재 화면 또는 컨테이너의 모바일 뷰 여부 판별 (태블릿-S / 876px 이하 또는 우측 패널 숨김)
         * @param {HTMLElement} [rootPane] - 화면 컨테이너 요소
         * @returns {boolean}
         */
        isMobileView: function(rootPane) {
            var root = rootPane || (window.currentPane || document);
            var right = (root && root.querySelector) ? (root.querySelector('.split-right') || root.querySelector('.report-card') || root.querySelector('.pane-right')) : null;
            if (right && window.getComputedStyle(right).display === 'none') {
                return true;
            }
            var width = (root && root.clientWidth > 0) ? root.clientWidth : window.innerWidth;
            return width <= 876;
        },

        /**
         * 대상 iframe에 리포트 URL 설정 (기본 zoom=120 적용)
         */
        setFrameSrc: function(frameEl, url, zoom) {
            if (!frameEl) return;
            if (!url || url === 'about:blank') {
                frameEl.src = 'about:blank';
                return;
            }
            frameEl.src = this.formatPreviewUrl(url, zoom);
        },

        /**
         * 표준 리포트 뷰어 & 내보내기 & 모바일 모달 일체형 자동 바인딩 엔진
         * @param {HTMLElement} rootPane - 화면의 탭 컨텍스트 엘리먼트 (currentPane / pane)
         * @param {Object} config - 설정 옵션
         * @param {Tabulator} [config.grid] - 연동 그리드 인스턴스 (리사이즈 시 redraw 자동 호출)
         */
        bindViewer: function(rootPane, config) {
            config = config || {};
            var root = rootPane || document;
            var iframe = root.querySelector(config.iframeSelector || '#report-frame, .report-frame');
            var loadingEl = root.querySelector(config.loadingSelector || '#preview-loading, .report-loading');
            var statusEl = root.querySelector(config.statusSelector || '#preview-status, .preview-status');
            var modalEl = root.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop')
                       || document.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop');
            var modalIframe = modalEl ? modalEl.querySelector('iframe') : null;
            var modalLoadingEl = modalEl ? modalEl.querySelector('.report-loading, [id*="loading"]') : null;
            var modalTitleEl = modalEl ? modalEl.querySelector('.modal-title, .report-modal-title') : null;
            var btnOpenNewWindow = root.querySelector('#btnOpenNewWindow, .btn-open-new-window');
            var btnCloseModal = modalEl ? modalEl.querySelector('.btn-close-modal, .btn-close-report-modal, [id*="Close"]') : null;
            
            var selectedData = null;
            var lastLoadedKey = null;

            function resolveMrd(data) {
                if (typeof config.mrdName === 'function') return config.mrdName(data);
                if (config.mrdName) return config.mrdName;
                if (typeof config.reportFile === 'function') return config.reportFile(data);
                return config.reportFile || '';
            }

            function resolveParams(data) {
                if (typeof config.getParams === 'function') return config.getParams(data);
                if (typeof config.buildParams === 'function') return config.buildParams(data);
                return data || {};
            }

            function resolveCorp() {
                if (typeof config.getCorpGr === 'function') return config.getCorpGr();
                if (typeof window.resolveCorpGr === 'function') return window.resolveCorpGr(root);
                return '';
            }

            function resolveDataKey(data) {
                if (!data) return '';
                var corp = resolveCorp();
                var ymd = (typeof config.getYmd === 'function') ? config.getYmd() : (typeof window.resolveFilterYmd === 'function' ? window.resolveFilterYmd(root) : '');
                var id = data.fundCd || data.fund_cd || data.id || data.mainKey || data.code || '';
                if (id) {
                    return corp + '_' + ymd + '_' + id;
                }
                try {
                    return corp + '_' + ymd + '_' + JSON.stringify(resolveParams(data));
                } catch (e) {
                    return String(data);
                }
            }

            function showLoading(show) {
                if (loadingEl) loadingEl.style.display = show ? 'block' : 'none';
                if (modalLoadingEl) modalLoadingEl.style.display = show ? 'block' : 'none';
            }

            function updateStatus(text) {
                if (statusEl) statusEl.textContent = text || '';
                if (typeof config.onStatusChange === 'function') config.onStatusChange(selectedData, text);
            }

            function load(data, statusText, isForce) {
                if (!data) return;
                selectedData = data;
                
                var dataKey = resolveDataKey(data);
                var isAlreadyLoaded = (lastLoadedKey === dataKey) && iframe && iframe.src && iframe.src !== 'about:blank' && !iframe.src.endsWith('about:blank');

                if (statusText) {
                    updateStatus(statusText);
                } else if (typeof config.getStatus === 'function') {
                    updateStatus(config.getStatus(data, resolveParams(data)));
                }
                if (typeof config.getTitle === 'function') {
                    var titleEl = root.querySelector('#preview-header-title, .preview-header-title');
                    if (titleEl) {
                        var titleVal = config.getTitle(data);
                        var iconClass = config.iconClass || 'fa-solid fa-file-invoice';
                        titleEl.innerHTML = '<i class="' + iconClass + '" style="margin-right: 4px;"></i> ' + titleVal;
                    }
                }

                // 이미 동일한 데이터의 리포트가 정상 로드되어 있고 강제 새로고침(isForce)이 아니라면 중복 로드 차단
                if (isAlreadyLoaded && !isForce) {
                    return;
                }
                lastLoadedKey = dataKey;

                if (typeof config.onBeforePreview === 'function') {
                    config.onBeforePreview(data);
                }

                var mrd = resolveMrd(data);
                var params = resolveParams(data);
                var previewUrl = (typeof config.buildPreviewUrl === 'function')
                    ? config.buildPreviewUrl(data, params)
                    : (mrd ? AamsReport.buildPreviewUrl(mrd, params, { corpGr: resolveCorp(), zoom: config.zoom }) : null);
                if (!previewUrl) return;
                
                showLoading(true);
                if (iframe) {
                    iframe.onload = function() { showLoading(false); };
                    AamsReport.setFrameSrc(iframe, previewUrl, config.zoom);
                }
                if (modalIframe && modalEl && modalEl.style.display !== 'none') {
                    modalIframe.onload = function() { showLoading(false); };
                    AamsReport.setFrameSrc(modalIframe, previewUrl, config.zoom);
                }
            }

            function clear() {
                selectedData = null;
                lastLoadedKey = null;
                updateStatus(config.defaultStatus || '선택된 항목 없음');
                if (iframe) AamsReport.setFrameSrc(iframe, 'about:blank');
                if (modalIframe) AamsReport.setFrameSrc(modalIframe, 'about:blank');
                showLoading(false);
            }

            function exportReport(format) {
                if (!selectedData) {
                    if (typeof window.showToast === 'function') window.showToast('내보낼 항목을 먼저 선택해주세요.', 'warning');
                    else alert('내보낼 항목을 먼저 선택해주세요.');
                    return;
                }
                if (typeof config.beforeAction === 'function' && config.beforeAction(selectedData, 'export') === false) return;
                var mrd = resolveMrd(selectedData);
                var params = resolveParams(selectedData);
                var dlName = typeof config.getDownloadName === 'function' ? config.getDownloadName(selectedData, format) : null;
                var url = (typeof config.buildExportUrl === 'function')
                    ? config.buildExportUrl(selectedData, format, params)
                    : AamsReport.buildExportUrl(mrd, params, format, {
                        corpGr: resolveCorp(),
                        downloadName: dlName
                    });
                if (url) window.location.href = url;
            }

            function openNewWindow() {
                if (!selectedData) {
                    if (typeof window.showToast === 'function') window.showToast('조회할 항목을 먼저 선택해주세요.', 'warning');
                    else alert('조회할 항목을 먼저 선택해주세요.');
                    return;
                }
                if (typeof config.beforeAction === 'function' && config.beforeAction(selectedData, 'newWindow') === false) return;
                var mrd = resolveMrd(selectedData);
                var params = resolveParams(selectedData);
                var url = (typeof config.buildPreviewUrl === 'function')
                    ? config.buildPreviewUrl(selectedData, params)
                    : AamsReport.buildPreviewUrl(mrd, params, { corpGr: resolveCorp(), zoom: config.zoom });
                if (url) window.open(url, '_blank');
            }

            function openModal(data, title) {
                if (!modalEl) {
                    modalEl = root.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop')
                           || document.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop');
                }
                if (!modalEl) return;
                selectedData = data || selectedData;
                if (!title && typeof config.getTitle === 'function' && selectedData) {
                    title = config.getTitle(selectedData);
                }
                if (modalTitleEl && title) modalTitleEl.textContent = title;
                modalEl.style.display = 'flex';
                if (modalIframe && selectedData) {
                    var mrd = resolveMrd(selectedData);
                    var params = resolveParams(selectedData);
                    var modalZoom = (config.mobileZoom !== undefined) ? config.mobileZoom : (config.zoom !== undefined ? config.zoom : AamsReport.DEFAULT_ZOOM);
                    var url = (typeof config.buildPreviewUrl === 'function')
                        ? config.buildPreviewUrl(selectedData, params)
                        : AamsReport.buildPreviewUrl(mrd, params, { corpGr: resolveCorp(), zoom: modalZoom });
                    showLoading(true);
                    modalIframe.onload = function() { showLoading(false); };
                    AamsReport.setFrameSrc(modalIframe, url, modalZoom);
                }
            }

            function closeModal() {
                if (modalEl) modalEl.style.display = 'none';
                if (modalIframe) AamsReport.setFrameSrc(modalIframe, 'about:blank');
            }

            // Export buttons binding
            var exportBtns = root.querySelectorAll('.btn-export-format, .export-btn, [data-format]');
            exportBtns.forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    var fmt = btn.getAttribute('data-format');
                    if (fmt) exportReport(fmt);
                });
            });

            // New window button
            if (btnOpenNewWindow) {
                btnOpenNewWindow.addEventListener('click', function(e) {
                    e.preventDefault();
                    openNewWindow();
                });
            }

            // Modal close button & backdrop
            if (btnCloseModal) {
                btnCloseModal.addEventListener('click', closeModal);
            }
            if (modalEl && typeof window.setupModalBackdrop === 'function') {
                window.setupModalBackdrop(modalEl, closeModal);
            }

            // =========================================================================
            // [전역 표준 공통 통합] 내장 스마트 반응형 리사이즈 핸들러
            // 1. 탭 닫힘 자동 감지 및 리스너 파기 (메모리 누수 및 좀비 쿼리 원천 차단)
            // 2. 비활성 백그라운드 탭 리사이즈 무시
            // 3. 연동 Tabulator 그리드(config.grid) 자동 redraw 동기화
            // 4. 모바일 <-> PC 모드 전환 시에만 리포트 패널/모달 스마트 복원
            // =========================================================================
            var lastIsMobile = AamsReport.isMobileView(root);
            var autoResizeTimer = null;

            function smartResizeHandler() {
                // 1) 탭이 닫혀 문서(DOM)에서 제거되었으면 리스너 영구 파기
                if (root && root !== document && !document.contains(root)) {
                    window.removeEventListener('resize', debouncedResize);
                    return;
                }
                // 2) 현재 활성화된 탭이 아니면 연산/API 호출 차단
                if (root && root.classList && root.classList.contains('tab-pane') && !root.classList.contains('active')) {
                    return;
                }

                // 3) 연동 그리드가 있으면 redraw 실행 (인스턴스 또는 함수 지원)
                var targetGrid = (typeof config.grid === 'function') ? config.grid() : (config.grid || (typeof config.getGrid === 'function' ? config.getGrid() : null));
                if (targetGrid && typeof targetGrid.redraw === 'function') {
                    targetGrid.redraw();
                }

                // 4) 모바일 <-> PC 뷰포트 전환 감지
                var currentIsMobile = AamsReport.isMobileView(root);
                if (lastIsMobile !== currentIsMobile) {
                    lastIsMobile = currentIsMobile;
                    if (!currentIsMobile) {
                        // 모바일 -> PC 전환 시: 모바일 모달 닫기 & PC 분할 리포트 패널 복원
                        closeModal();
                        if (selectedData && iframe) {
                            load(selectedData, null, true);
                        }
                    }
                }
            }

            function debouncedResize() {
                clearTimeout(autoResizeTimer);
                autoResizeTimer = setTimeout(smartResizeHandler, 120);
            }

            window.addEventListener('resize', debouncedResize);

            var viewerInstance = {
                load: load,
                loadPreview: load,
                clear: clear,
                openModal: openModal,
                openMobile: openModal,
                closeModal: closeModal,
                closeMobile: closeModal,
                openNewWindow: openNewWindow,
                exportReport: exportReport,
                exportFormat: exportReport,
                syncResize: smartResizeHandler,
                getSelectedData: function() { return selectedData; },
                setSelectedData: function(d) { selectedData = d; },
                destroy: function() {
                    window.removeEventListener('resize', debouncedResize);
                    clear();
                }
            };

            // 탭 요소에 인스턴스 참조 캐싱
            if (root && typeof root === 'object') {
                root._aamsReportViewer = viewerInstance;
            }

            return viewerInstance;
        }
    };

    window.AamsReport = AamsReport;

})(window);
