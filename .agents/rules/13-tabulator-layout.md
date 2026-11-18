---
trigger: always_on
---

# 13. Tabulator Layout Standard

- Every `new Tabulator(...)` definition in a newly created or modified screen must explicitly set `layout: "fitDataFill"`.
- Do not use `fitColumns`, `fitData`, or `fitDataStretch` for screen grids. Existing exceptions must be converted as part of the related screen change.
- Define intentional column widths with `width`, `minWidth`, or `widthGrow`; `fitDataFill` then uses available pane width without stretching data columns unnecessarily.
- When a grid is meant to fill its pane vertically, keep `height: "100%"` and ensure each parent layout container has a resolved height.
