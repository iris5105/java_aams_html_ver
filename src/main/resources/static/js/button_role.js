/**
 * PowerBuilder pf_n_buttonrole 대응 공통 버튼 권한 제어 모듈 (button_role.js)
 * 1. 각 화면 열람(MDI 탭 생성/전환) 시 접속자의 프로그램별 버튼 권한(fw_d_commbtnauth)을 판별하여
 *    상단 툴바 버튼([새로고침], [조회], [입력], [복사], [삭제], [저장], [인쇄], [엑셀])의 노출/숨김을 제어합니다.
 * 2. 화면의 마스터그리드 조회 실행 상태(isSearched)에 따른 버튼 활성화/비활성화 제어:
 *    - 조회 전(초기/새로고침 후): [닫기], [조회]만 활성화, 나머지 버튼은 비활성화(disabled, 시각적 딤 처리 및 기능 차단)
 *    - 조회 완료 후: [조회] 비활성화, [닫기] 및 나머지 권한 보유 버튼 활성화
 */
(function(window) {
    'use strict';

    const ButtonRole = {
        // 프로그램 번호(pgmNo)별 권한 캐시 (불필요한 반복 API 호출 방지)
        _authCache: {},

        /**
         * 백엔드 API로부터 특정 프로그램의 버튼 권한 조회
         * @param {string} pgmNo - 프로그램 번호 (예: '00052')
         * @returns {Promise<Object>} ButtonAuthDto 객체
         */
        fetchAuth: function(pgmNo) {
            if (!pgmNo || typeof pgmNo !== 'string') {
                return Promise.resolve(this._getDefaultAuth());
            }

            const cleanPgmNo = pgmNo.trim();
            if (this._authCache[cleanPgmNo]) {
                return Promise.resolve(this._authCache[cleanPgmNo]);
            }

            const url = '/api/common/button-auth?pgmNo=' + encodeURIComponent(cleanPgmNo);

            return fetch(url)
                .then(function(res) {
                    if (!res.ok) {
                        throw new Error('HTTP ' + res.status + ' while fetching button auth');
                    }
                    return res.json();
                })
                .then(function(data) {
                    ButtonRole._authCache[cleanPgmNo] = data;
                    return data;
                })
                .catch(function(err) {
                    console.warn('[ButtonRole] Failed to fetch button auth for ' + cleanPgmNo + ':', err);
                    // 에러 발생 시 모든 버튼을 활성화하는 Fallback 반환
                    const fallback = ButtonRole._getDefaultAuth(cleanPgmNo);
                    ButtonRole._authCache[cleanPgmNo] = fallback;
                    return fallback;
                });
        },

        /**
         * 화면 컨테이너(pane) 내부의 툴바 버튼에 권한 적용
         * @param {HTMLElement} pane - 탭 패널 또는 화면 뷰 컨테이너
         * @param {string} [pgmNo] - 프로그램 번호 (생략 시 pane의 data-pgm-no에서 자동 추출)
         */
        apply: function(pane, pgmNo) {
            if (!pane) return;

            const targetPgmNo = pgmNo || pane.getAttribute('data-pgm-no') || (window.g_currentPgmNo ? String(window.g_currentPgmNo) : null);
            if (!targetPgmNo) {
                return;
            }

            this.fetchAuth(targetPgmNo).then(function(auth) {
                ButtonRole._applyAuthToPane(pane, auth);
            });
        },

        /**
         * 내부 DOM 요소들에 권한 반영
         */
        _applyAuthToPane: function(pane, auth) {
            if (!pane || !auth) return;

            // pane에 현재 권한 정보 바인딩
            pane.buttonAuth = auth;

            // 1. 공통 버튼 활성화 권한(commBtnAuthYn) 체크
            // commBtnAuthYn이 false이면 툴바 액션 버튼 전체 숨김 (닫기 제외)
            const toolbarButtons = pane.querySelector('.toolbar-buttons');
            if (toolbarButtons) {
                if (auth.commBtnAuthYn === false) {
                    toolbarButtons.style.display = 'none';
                    return;
                } else {
                    toolbarButtons.style.display = '';
                }
            }

            // 2. 파워빌더 pf_n_buttonrole.sru 및 w_window1st1ncn.srw of_initbutton 대응 매핑 (노출/숨김)
            const buttonMappings = [
                { selector: '.btn-refresh', auth: auth.cancelAuthYn },    // 새로고침 (cancel_auth_yn)
                { selector: '.btn-search',  auth: auth.retrieveAuthYn },  // 조회 (retrieve_auth_yn)
                { selector: '.btn-input',   auth: auth.inputAuthYn },     // 입력 (input_auth_yn)
                { selector: '.btn-copy',    auth: auth.ext1AuthYn },      // 복사 (ext1_auth_yn)
                { selector: '.btn-delete',  auth: auth.deleteAuthYn },    // 삭제 (delete_auth_yn)
                { selector: '.btn-save',    auth: auth.updateAuthYn },    // 저장 (update_auth_yn)
                { selector: '.btn-print',   auth: auth.printAuthYn },     // 인쇄 (print_auth_yn)
                { selector: '.btn-excel',   auth: auth.excelAuthYn }      // 엑셀 (excel_auth_yn)
            ];

            buttonMappings.forEach(function(item) {
                const btn = pane.querySelector(item.selector);
                if (btn) {
                    if (item.auth) {
                        btn.style.display = ''; // CSS 기본 display 적용
                    } else {
                        btn.style.display = 'none'; // 권한 미보유 시 숨김 처리
                    }
                }
            });

            // 3. 마스터그리드 조회 실행 여부에 따른 초기 활성화/비활성화 상태 설정
            // 화면 초기 진입 시 기본값은 "조회 전" 상태 (pane.isSearched가 true가 아니면 false)
            this.setSearchState(pane, !!pane.isSearched);
            setTimeout(function() {
                if (pane) {
                    ButtonRole.setSearchState(pane, !!pane.isSearched);
                }
            }, 100);

            // 권한 적용 완료 커스텀 이벤트 디스패치
            pane.dispatchEvent(new CustomEvent('buttonAuthApplied', {
                bubbles: true,
                detail: { auth: auth, pgmNo: auth.pgmNo }
            }));
        },

        /**
         * 화면 컨테이너에 실제로 노출되는 새로고침 버튼이 존재하는지 여부 확인
         * @param {HTMLElement} container
         * @returns {boolean}
         */
        _hasVisibleRefreshButton: function(container) {
            if (!container) return false;
            const btnRefresh = container.querySelector('.btn-refresh');
            if (!btnRefresh) return false;
            const isInlineNone = btnRefresh.style.display === 'none' || btnRefresh.classList.contains('d-none');
            const computedDisplay = (window.getComputedStyle && btnRefresh.isConnected) ? window.getComputedStyle(btnRefresh).display : '';
            return (!isInlineNone && computedDisplay !== 'none');
        },

        /**
         * 마스터그리드 조회 실행 상태(isSearched)에 따른 버튼 및 필터 활성화/비활성화 제어
         * @param {HTMLElement} pane - 화면 컨테이너 (탭 패널)
         * @param {boolean} isSearched - true: 조회 실행 완료, false: 조회 실행 전(초기화 상태)
         */
        setSearchState: function(pane, isSearched) {
            if (!pane) return;
            const container = pane.closest ? (pane.closest('.tab-pane') || pane) : pane;
            container.isSearched = !!isSearched;

            // 1. 상단 툴바 버튼 활성화/비활성화 제어
            const btnClose = container.querySelector('.btn-close');
            const btnSearch = container.querySelector('.btn-search');
            const otherButtons = container.querySelectorAll(
                '.toolbar-buttons .t-btn:not(.btn-search)'
            );

            // 새로고침 버튼 존재 및 실제 노출 여부 확인
            const hasRefreshButton = this._hasVisibleRefreshButton(container);

            if (isSearched) {
                // [조회 실행 완료 후]
                // 1) 닫기 버튼: 활성화
                if (btnClose) this._setElementEnabled(btnClose, true);

                // 2) 조회 버튼: 조건 변경 후 언제든지 재조회할 수 있도록 항상 활성화 유지 (웹 표준 UX 방안 A)
                if (btnSearch) this._setElementEnabled(btnSearch, true);

                // 3) 조회 버튼을 제외한 나머지 권한 버튼들: 활성화
                otherButtons.forEach(function(btn) {
                    ButtonRole._setElementEnabled(btn, true);
                });
            } else {
                // [조회 실행 전 (초기 진입 또는 새로고침 후)]
                // 1) 닫기 버튼: 활성화
                if (btnClose) this._setElementEnabled(btnClose, true);

                // 2) 조회 버튼: 활성화
                if (btnSearch) this._setElementEnabled(btnSearch, true);

                // 3) 닫기와 조회를 제외한 나머지 버튼들: 비활성화 (보여지되 기능 차단 및 시각적 딤)
                otherButtons.forEach(function(btn) {
                    ButtonRole._setElementEnabled(btn, false);
                });
            }

            // 2. filter-bar 내의 mastergrid 조건(Calendar, DDDW, Search 등) 및 서브 액션 버튼 제어
            this._updateFilterBarState(container, !!isSearched);

            container.dispatchEvent(new CustomEvent('buttonSearchStateChanged', {
                bubbles: true,
                detail: { isSearched: !!isSearched, pane: container }
            }));
        },

        /**
         * filter-bar 내부의 마스터그리드 조건 컨트롤과 서브 액션 버튼 활성화/비활성화
         * @param {HTMLElement} container - 탭 패널 컨테이너
         * @param {boolean} isSearched - 조회 실행 여부 (방안 A: 필터는 항상 활성화 유지)
         */
        _updateFilterBarState: function(container, isSearched) {
            if (!container) return;
            const filterBars = container.querySelectorAll('.filter-bar');
            if (!filterBars || filterBars.length === 0) return;

            // 웹 표준 UX 방안 A: 상단 filter 부분(달력, 날짜, DDDW, 코드검색 등)은 조회 여부와 관계없이 항상 활성화 상태 유지
            const isConditionEnabled = true;

            // Calendar, DDDW, Dynamic Search 관련 요소 판별 헬퍼
            function isConditionControl(el) {
                if (!el) return false;

                // 1. Calendar 관련 판별
                if (el.classList.contains('btn-calendar') ||
                    el.classList.contains('btn-range-calendar') ||
                    el.closest('.aams-calendar-wrapper') ||
                    el.closest('.range-calendar-wrapper') ||
                    (el.getAttribute('onclick') && el.getAttribute('onclick').includes('AamsCalendar')) ||
                    (el.id && (el.id.toLowerCase().includes('calendar') || el.id.toLowerCase().includes('ymd'))) ||
                    (el.name && (el.name.toLowerCase().includes('ymd') || el.name.toLowerCase().includes('date'))) ||
                    (el.querySelector && (el.querySelector('.fa-calendar') || el.querySelector('.fa-calendar-days') || el.querySelector('.fa-calendar-week')))) {
                    return true;
                }

                // 2. DDDW 관련 판별
                if (el.classList.contains('dddw-select-btn') ||
                    el.classList.contains('dddw-select-custom') ||
                    el.closest('.dddw-select-custom') ||
                    (el.tagName === 'SELECT' && !el.classList.contains('btn-action')) ||
                    (el.id && (el.id.toLowerCase().includes('dddw') || el.id.toLowerCase().includes('corpgr'))) ||
                    (el.name && (el.name.toLowerCase().includes('dddw') || el.name.toLowerCase().includes('corp_gr')))) {
                    return true;
                }

                // 3. Dynamic Search 관련 판별
                if (el.classList.contains('btn-search-icon') ||
                    el.classList.contains('code-search-btn') ||
                    el.closest('.code-search-wrapper') ||
                    (el.getAttribute('onclick') && (el.getAttribute('onclick').includes('Search') || el.getAttribute('onclick').includes('CodeSearch') || el.getAttribute('onclick').includes('openSearch'))) ||
                    (el.id && (el.id.toLowerCase().includes('search') && !el.id.toLowerCase().includes('action'))) ||
                    (el.querySelector && (el.querySelector('.fa-magnifying-glass') || el.querySelector('.fa-search')) && (el.title && el.title.includes('검색') || el.classList.contains('btn-search-icon') || !el.textContent.trim()))) {
                    return true;
                }

                return false;
            }

            filterBars.forEach(function(filterBar) {
                // (1) calendar, dddw, dynamicsearch와 연관되지 않은 다른 목적을 가진 모든 버튼들 식별
                // (예: NEW체결, 체결등록, 잔고LOAD, 예수금LOAD, 신용/대출잔고LOAD, 종가LOAD, 평잔재계산 등)
                const allButtons = filterBar.querySelectorAll('button, input[type="button"], input[type="submit"], .t-btn');
                const otherActionButtons = [];

                allButtons.forEach(function(btn) {
                    if (!isConditionControl(btn)) {
                        otherActionButtons.push(btn);
                    }
                });

                // 요구사항 반영: filter-bar에 위치한 다른 목적의 버튼들은 조회 여부와 상관없이 항상 활성화 상태 유지
                otherActionButtons.forEach(function(btn) {
                    ButtonRole._setElementEnabled(btn, true);
                });

                // (2) 마스터그리드 조건 컨트롤 (날짜 인풋, 달력 버튼, DDDW 셀렉트/버튼, 검색 인풋/돋보기 버튼 등) 식별
                const conditionElements = [];
                const allInputs = filterBar.querySelectorAll('input:not([type="button"]):not([type="submit"]), select, textarea');
                allInputs.forEach(function(input) {
                    if (!otherActionButtons.includes(input)) {
                        conditionElements.push(input);
                    }
                });

                allButtons.forEach(function(btn) {
                    if (isConditionControl(btn) && !otherActionButtons.includes(btn)) {
                        conditionElements.push(btn);
                    }
                });

                // 마스터그리드 조건 컨트롤 활성화/비활성화 적용 (조회 전 활성화, 조회 후 비활성화)
                conditionElements.forEach(function(el) {
                    ButtonRole._setFilterControlEnabled(el, isConditionEnabled);
                });

                // 래퍼 컨테이너(.aams-calendar-wrapper, .range-calendar-wrapper, .dddw-select-custom, .code-search-wrapper) 비활성화 스타일 클래스 동기화
                const wrappers = filterBar.querySelectorAll(
                    '.aams-calendar-wrapper, .range-calendar-wrapper, .dddw-select-custom, .code-search-wrapper'
                );
                wrappers.forEach(function(w) {
                    if (isConditionEnabled) {
                        w.classList.remove('disabled');
                        w.removeAttribute('aria-disabled');
                        w.style.pointerEvents = '';
                    } else {
                        w.classList.add('disabled');
                        w.setAttribute('aria-disabled', 'true');
                        w.style.pointerEvents = 'none';
                    }
                });
            });
        },

        /**
         * 개별 필터 컨트롤(날짜 인풋, 달력 버튼, DDDW 드롭다운, 검색 인풋 등)의 활성화/비활성화 설정
         */
        _setFilterControlEnabled: function(el, isEnabled) {
            if (!el) return;

            // 관리자가 아닌 사용자의 운용사 드롭다운 고정 잠금은 해제하지 않음
            if (el.id === 'filterCorpGr' && el.title && el.title.includes('관리자 전용') && isEnabled) {
                return;
            }

            if (isEnabled) {
                el.disabled = false;
                el.removeAttribute('disabled');
                el.classList.remove('disabled');
                el.classList.remove('filter-disabled');
                el.removeAttribute('aria-disabled');
                el.style.pointerEvents = '';
                if (el.tagName === 'INPUT') {
                    if (!el.classList.contains('aams-calendar-input') && !el.classList.contains('range-calendar-input')) {
                        el.readOnly = false;
                        el.removeAttribute('readonly');
                    }
                }
            } else {
                el.disabled = true;
                el.setAttribute('disabled', 'disabled');
                el.classList.add('disabled');
                el.classList.add('filter-disabled');
                el.setAttribute('aria-disabled', 'true');
                el.style.pointerEvents = 'none';
                if (el.tagName === 'INPUT') {
                    el.readOnly = true;
                    el.setAttribute('readonly', 'readonly');
                }
            }
        },

        /**
         * 단일 요소(버튼, 인풋, 셀렉트 등)의 활성화/비활성화 속성 및 스타일 클래스 설정
         */
        _setElementEnabled: function(el, isEnabled) {
            if (!el) return;
            if (isEnabled) {
                el.disabled = false;
                el.removeAttribute('disabled');
                el.classList.remove('disabled');
                el.removeAttribute('aria-disabled');
                if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                    el.readOnly = false;
                    el.removeAttribute('readonly');
                }
                el.style.pointerEvents = '';
            } else {
                el.disabled = true;
                el.setAttribute('disabled', 'disabled');
                el.classList.add('disabled');
                el.setAttribute('aria-disabled', 'true');
                if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                    el.readOnly = true;
                    el.setAttribute('readonly', 'readonly');
                }
                el.style.pointerEvents = 'none';
            }
        },

        /**
         * 캐시된 특정 프로그램 권한 취득
         */
        getAuth: function(pgmNo) {
            if (!pgmNo) return null;
            return this._authCache[pgmNo.trim()] || null;
        },

        /**
         * 특정 버튼 권한 보유 여부 확인
         */
        hasAuth: function(pgmNo, buttonType) {
            const auth = this.getAuth(pgmNo);
            if (!auth) return true; // 권한 미로드 시 기본 허용
            if (auth.commBtnAuthYn === false) return false;

            switch (buttonType) {
                case 'refresh':
                case 'cancel':
                    return !!auth.cancelAuthYn;
                case 'search':
                case 'retrieve':
                    return !!auth.retrieveAuthYn;
                case 'input':
                case 'insert':
                    return !!auth.inputAuthYn;
                case 'copy':
                    return !!auth.ext1AuthYn;
                case 'save':
                case 'update':
                    return !!auth.updateAuthYn;
                case 'delete':
                    return !!auth.deleteAuthYn;
                case 'print':
                    return !!auth.printAuthYn;
                case 'excel':
                    return !!auth.excelAuthYn;
                default:
                    return true;
            }
        },

        /**
         * 캐시 초기화 (로그아웃 또는 권한 갱신 시)
         */
        clearCache: function() {
            this._authCache = {};
        },

        /**
         * 기본 전체 허용 권한 객체
         */
        _getDefaultAuth: function(pgmNo) {
            return {
                pgmNo: pgmNo || '',
                commBtnAuthYn: true,
                cancelAuthYn: true,
                retrieveAuthYn: true,
                inputAuthYn: true,
                ext1AuthYn: true,
                updateAuthYn: true,
                deleteAuthYn: true,
                printAuthYn: true,
                excelAuthYn: true,
                executeAuthYn: true,
                indivBtnAuthYn: true
            };
        }
    };

    window.ButtonRole = ButtonRole;

})(window);
