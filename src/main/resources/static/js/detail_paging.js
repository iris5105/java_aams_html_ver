/*
 * Detail grid server paging helper.
 * A screen supplies only its page request and data-binding callbacks.
 */
(function (window) {
    "use strict";

    function create(options) {
        var pane = options && options.pane;
        if (!pane) throw new Error("AamsDetailPaging requires a pane.");

        var pageSize = options.pageSize || 50;
        var currentPage = 0;
        var lastPage = 0;
        var loader = options.loadPage || null;

        var input = pane.querySelector(options.inputSelector || "#inputDetailPage");
        var total = pane.querySelector(options.totalSelector || "#textDetailPageTotal");
        var first = pane.querySelector(options.firstSelector || "#btnDetailPageFirst");
        var prev = pane.querySelector(options.prevSelector || "#btnDetailPagePrev");
        var next = pane.querySelector(options.nextSelector || "#btnDetailPageNext");
        var last = pane.querySelector(options.lastSelector || "#btnDetailPageLast");

        function render() {
            var hasPage = lastPage > 0;
            if (input) {
                input.value = hasPage ? currentPage : 0;
                input.max = hasPage ? lastPage : 0;
                input.disabled = !hasPage;
            }
            if (total) total.textContent = "/ " + lastPage;
            if (first) first.disabled = !hasPage || currentPage <= 1;
            if (prev) prev.disabled = !hasPage || currentPage <= 1;
            if (next) next.disabled = !hasPage || currentPage >= lastPage;
            if (last) last.disabled = !hasPage || currentPage >= lastPage;
        }

        function reset() {
            currentPage = 0;
            lastPage = 0;
            render();
        }

        function load(page) {
            if (typeof loader !== "function") return Promise.resolve();
            var requestedPage = page > 0 ? page : 1;
            if (lastPage > 0) requestedPage = Math.min(requestedPage, lastPage);

            if (typeof options.onLoading === "function") options.onLoading(true);
            return Promise.resolve(loader(requestedPage, pageSize))
                .then(function (result) {
                    var response = result || {};
                    lastPage = Number(response.lastPage) > 0 ? Number(response.lastPage) : 0;
                    currentPage = lastPage > 0 ? Math.min(requestedPage, lastPage) : 0;
                    render();
                    return typeof options.onLoaded === "function"
                        ? Promise.resolve(options.onLoaded(response.data || [], currentPage, lastPage))
                        : null;
                })
                .catch(function (error) {
                    reset();
                    if (typeof options.onError === "function") options.onError(error);
                    else throw error;
                })
                .finally(function () {
                    if (typeof options.onLoading === "function") options.onLoading(false);
                });
        }

        function move(page) {
            if (lastPage > 0 && page !== currentPage) return load(page);
            return Promise.resolve();
        }

        if (first) first.onclick = function () { move(1); };
        if (prev) prev.onclick = function () { move(currentPage - 1); };
        if (next) next.onclick = function () { move(currentPage + 1); };
        if (last) last.onclick = function () { move(lastPage); };
        if (input) {
            input.onchange = function () {
                var page = Number(input.value);
                if (!Number.isInteger(page) || page < 1 || page > lastPage) {
                    render();
                    return;
                }
                move(page);
            };
            input.onkeydown = function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    input.onchange();
                }
            };
        }

        render();
        return {
            setLoader: function (value) { loader = value; },
            load: load,
            reset: reset,
            getPage: function () { return currentPage; },
            getLastPage: function () { return lastPage; }
        };
    }

    window.AamsDetailPaging = { create: create };
})(window);
