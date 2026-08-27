/**
 * Tabbed MDI Container Manager (Max 10 Tabs)
 * Supports F5 / Page Refresh State Persistence via sessionStorage.
 */
class TabManager {
    constructor() {
        this.maxTabs = 10;
        this.openTabs = []; // [{ pgmNo, pgmId, pgmGo, tabKey, title, url, breadcrumb }]
        this.activeTabKey = null;
        this.isRestoring = false;
    }

    init() {
        this.openTabs = [];
        this.activeTabKey = null;
        const restored = this.restoreStateFromStorage();
        if (!restored) {
            this.updateHomeVisibility();
        }
    }

    saveStateToStorage() {
        if (this.isRestoring) return;
        try {
            const state = {
                openTabs: this.openTabs.map(t => ({
                    pgmNo: t.pgmNo,
                    pgmId: t.pgmId,
                    pgmGo: t.pgmGo,
                    title: t.title,
                    url: t.url,
                    breadcrumb: t.breadcrumb
                })),
                activeTabKey: this.activeTabKey
            };
            sessionStorage.setItem("AAMS_MDI_TABS_STATE", JSON.stringify(state));
        } catch (e) {
            console.warn("Failed to save MDI tab state to storage:", e);
        }
    }

    restoreStateFromStorage() {
        try {
            const raw = sessionStorage.getItem("AAMS_MDI_TABS_STATE");
            if (!raw) return false;

            const state = JSON.parse(raw);
            if (!state || !Array.isArray(state.openTabs) || state.openTabs.length === 0) {
                return false;
            }

            this.isRestoring = true;
            state.openTabs.forEach(t => {
                this.openTab(t.pgmNo, t.pgmId, t.title, t.url, t.breadcrumb, t.pgmGo);
            });
            this.isRestoring = false;

            if (state.activeTabKey) {
                this.switchTab(state.activeTabKey);
            }

            return true;
        } catch (e) {
            console.warn("Failed to restore MDI tab state from storage:", e);
            this.isRestoring = false;
            return false;
        }
    }

    openTab(pgmNo, pgmId, title, url, breadcrumb, pgmGo) {
        if (!pgmNo) return;

        // Handle method overloading: openTab(pgmNo, title) where pgmId is omitted
        if (typeof pgmId === "string" && !title && (pgmId.includes(" ") || pgmId.length > 20)) {
            title = pgmId;
            pgmId = null;
        }

        // 1. Use pgmNo (or pgmId_pgmNo) as unique tabKey so identical pgmId programs (e.g. W_RUN) can open separate tabs
        const tabKey = (pgmNo && pgmNo.trim() !== "") ? pgmNo.trim() : (pgmId ? pgmId.trim() : "tab");

        // Check if tab is already open by exact tabKey
        const existingTab = this.openTabs.find(t => t.tabKey === tabKey);
        if (existingTab) {
            this.switchTab(existingTab.tabKey);
            return;
        }

        // 2. Check max tab limit (10 tabs)
        if (this.openTabs.length >= this.maxTabs) {
            alert("최대 10개의 탭까지만 열 수 있습니다.\n기존 탭을 닫은 후 다시 시도해주세요.");
            return;
        }

        // 3. Create new tab object
        const tabTitle = title || ("메뉴 " + pgmNo);
        const resolvedUrl = url || this.resolveMenuUrl(pgmId, pgmNo, pgmGo);

        const tabObj = {
            pgmNo: pgmNo,
            pgmId: pgmId,
            pgmGo: pgmGo || '',
            tabKey: tabKey,
            title: tabTitle,
            url: resolvedUrl,
            breadcrumb: breadcrumb
        };

        this.openTabs.push(tabObj);

        // 4. Create Tab Header Item in DOM
        const tabBar = document.getElementById("tabBar");
        if (tabBar) {
            const tabItem = document.createElement("div");
            tabItem.className = "tab-item";
            tabItem.id = "tab-header-" + tabKey;
            tabItem.setAttribute("data-tab-key", tabKey);
            tabItem.setAttribute("data-pgm-no", pgmNo);
            if (pgmId) tabItem.setAttribute("data-pgm-id", pgmId);
            if (pgmGo) tabItem.setAttribute("data-pgm-go", pgmGo);

            tabItem.onclick = (e) => {
                if (!e.target.classList.contains("tab-close-btn")) {
                    this.switchTab(tabKey);
                }
            };

            tabItem.innerHTML = `
                <span class="tab-title" title="${tabTitle}">${tabTitle}</span>
                <span class="tab-close-btn" onclick="tabManager.closeTab('${tabKey}', event)">&times;</span>
            `;
            tabBar.appendChild(tabItem);
        }

        // 5. Create Tab Content Pane in DOM
        const container = document.getElementById("tabContentContainer");
        if (container) {
            const pane = document.createElement("div");
            pane.className = "tab-pane";
            pane.id = "tab-pane-" + tabKey;
            pane.setAttribute("data-tab-key", tabKey);
            pane.setAttribute("data-pgm-no", pgmNo);
            if (pgmId) pane.setAttribute("data-pgm-id", pgmId);

            // Show loading indicator
            pane.innerHTML = `
                <div class="pane-loading" style="padding: 40px; text-align: center; color: #94a3b8;">
                    <i class="fa-solid fa-spinner fa-spin fa-2x"></i>
                    <p style="margin-top: 10px; font-size: 13px;">화면을 불러오는 중입니다... (${tabTitle})</p>
                </div>
            `;
            container.appendChild(pane);

            // 6. Fetch View Content
            fetch(tabObj.url)
                .then(res => {
                    if (!res.ok) throw new Error("HTTP error " + res.status);
                    return res.text();
                })
                .then(html => {
                    pane.innerHTML = html;

                    // Update FULLPGM2 Breadcrumb inside loaded view pane if available
                    if (tabObj.breadcrumb) {
                        const breadcrumbEl = pane.querySelector(".breadcrumb");
                        if (breadcrumbEl) {
                            breadcrumbEl.innerHTML = `<i class="fa-solid fa-house"></i> <span>${tabObj.breadcrumb}</span>`;
                        }
                    }

                    // Execute scripts if present inside loaded HTML
                    const scripts = pane.querySelectorAll("script");
                    scripts.forEach(oldScript => {
                        const newScript = document.createElement("script");
                        Array.from(oldScript.attributes).forEach(attr => newScript.setAttribute(attr.name, attr.value));
                        newScript.appendChild(document.createTextNode(oldScript.innerHTML));
                        oldScript.parentNode.replaceChild(newScript, oldScript);
                    });
                })
                .catch(err => {
                    console.error("Error loading tab view:", err);
                    pane.innerHTML = `
                        <div class="pane-error" style="padding: 40px; text-align: center; color: #f87171;">
                            <i class="fa-solid fa-triangle-exclamation fa-2x"></i>
                            <p style="margin-top: 10px; font-weight: 500;">화면을 불러오지 못했습니다.</p>
                            <p style="font-size: 12px; color: #94a3b8; margin-top: 5px;">${tabObj.url}</p>
                        </div>
                    `;
                });
        }

        // 7. Activate newly created tab
        this.switchTab(tabKey);
        this.saveStateToStorage();
    }

    switchTab(tabKey) {
        if (!tabKey) return;
        this.activeTabKey = tabKey;

        // Update Tab Header Classes
        document.querySelectorAll("#tabBar .tab-item").forEach(item => {
            if (item.getAttribute("data-tab-key") === tabKey || item.getAttribute("data-pgm-no") === tabKey) {
                item.classList.add("active");
                item.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' });
            } else {
                item.classList.remove("active");
            }
        });

        // Update Tab Content Panes Visibility
        document.querySelectorAll("#tabContentContainer .tab-pane").forEach(pane => {
            if (pane.getAttribute("data-tab-key") === tabKey || pane.getAttribute("data-pgm-no") === tabKey) {
                pane.classList.add("active");
                pane.style.display = "block";
            } else {
                pane.classList.remove("active");
                pane.style.display = "none";
            }
        });

        this.updateHomeVisibility();
        this.highlightSidebarMenu(tabKey);
        this.saveStateToStorage();
    }

    closeTab(tabKey, event) {
        if (event) event.stopPropagation();

        const idx = this.openTabs.findIndex(t => t.tabKey === tabKey || t.pgmNo === tabKey);
        if (idx === -1) return;

        const targetTab = this.openTabs[idx];
        const isCurrentActive = (this.activeTabKey === targetTab.tabKey || this.activeTabKey === targetTab.pgmNo);

        // Remove from state array
        this.openTabs.splice(idx, 1);

        // Remove DOM Header and Pane
        const headerEl = document.getElementById("tab-header-" + targetTab.tabKey);
        if (headerEl) headerEl.remove();

        const paneEl = document.getElementById("tab-pane-" + targetTab.tabKey);
        if (paneEl) paneEl.remove();

        // If closed tab was active, switch to adjacent tab
        if (isCurrentActive) {
            if (this.openTabs.length > 0) {
                const nextTab = this.openTabs[Math.max(0, idx - 1)];
                if (nextTab) {
                    this.switchTab(nextTab.tabKey);
                }
            } else {
                this.activeTabKey = null;
            }
        }

        this.updateHomeVisibility();
        this.saveStateToStorage();
    }

    closeCurrentTab() {
        if (this.activeTabKey) {
            this.closeTab(this.activeTabKey);
        }
    }

    closeAllTabs() {
        const keysToClose = this.openTabs.map(t => t.tabKey);
        keysToClose.forEach(key => {
            const headerEl = document.getElementById("tab-header-" + key);
            if (headerEl) headerEl.remove();

            const paneEl = document.getElementById("tab-pane-" + key);
            if (paneEl) paneEl.remove();
        });

        this.openTabs = [];
        this.activeTabKey = null;
        this.updateHomeVisibility();
        sessionStorage.removeItem("AAMS_MDI_TABS_STATE");
    }

    updateHomeVisibility() {
        const homePane = document.getElementById("homeWorkspacePane");
        const contentContainer = document.getElementById("tabContentContainer");
        const btnCloseAll = document.getElementById("btnCloseAllTabs");

        if (this.openTabs.length === 0) {
            if (homePane) homePane.style.display = "block";
            if (contentContainer) contentContainer.style.display = "none";
            if (btnCloseAll) btnCloseAll.style.display = "none";
            this.activeTabKey = null;
            this.highlightSidebarMenu(null);
        } else {
            if (homePane) homePane.style.display = "none";
            if (contentContainer) contentContainer.style.display = "block";
            if (btnCloseAll) btnCloseAll.style.display = "inline-flex";
        }
    }

    resolveMenuUrl(pgmId, pgmNo, pgmGo) {
        const targetId = (pgmId && pgmId.trim() !== "") ? pgmId.trim() : pgmNo;
        if (targetId) {
            let cleanId = targetId.replace(/\.srw$/i, '').toLowerCase();
            let queryParams = [];
            if (pgmNo) queryParams.push(`pgmNo=${encodeURIComponent(pgmNo)}`);
            if (pgmGo) queryParams.push(`pgmGo=${encodeURIComponent(pgmGo)}`);
            const queryString = queryParams.length > 0 ? `?${queryParams.join('&')}` : '';
            return "/views/" + cleanId + queryString;
        }
        return "/views/w_ja010b";
    }

    highlightSidebarMenu(tabKey) {
        if (!tabKey) {
            document.querySelectorAll(".tree-menu-item").forEach(el => el.classList.remove("active"));
            return;
        }

        const activeTab = this.openTabs.find(t => t.tabKey === tabKey || t.pgmNo === tabKey || t.pgmId === tabKey || t.pgmGo === tabKey);
        const activePgmNo = activeTab ? activeTab.pgmNo : tabKey;
        const activePgmId = activeTab ? activeTab.pgmId : tabKey;
        const activePgmGo = activeTab ? activeTab.pgmGo : null;

        document.querySelectorAll(".tree-menu-item").forEach(el => {
            const keyNo = el.getAttribute("data-pgm-no");
            const keyId = el.getAttribute("data-pgm-id");
            const keyGo = el.getAttribute("data-pgm-go");

            let isMatch = false;

            if (activePgmGo && keyGo && activePgmGo.trim() !== "" && keyGo.trim() !== "") {
                isMatch = (keyGo.trim() === activePgmGo.trim());
            } else if (activePgmId && keyId && activePgmId.trim() !== "" && keyId.trim() !== "") {
                isMatch = (keyId.trim() === activePgmId.trim());
            } else if (activePgmNo && keyNo && activePgmNo.trim() !== "" && keyNo.trim() !== "") {
                isMatch = (keyNo.trim() === activePgmNo.trim());
            } else {
                isMatch = (keyGo === tabKey || keyId === tabKey || keyNo === tabKey);
            }

            if (isMatch) {
                el.classList.add("active");
            } else {
                el.classList.remove("active");
            }
        });
    }
}

// Global Singleton Instance
window.tabManager = new TabManager();

document.addEventListener("DOMContentLoaded", function() {
    window.tabManager.init();
});
