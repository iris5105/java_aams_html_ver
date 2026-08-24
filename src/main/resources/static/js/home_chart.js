/**
 * W_HOME5 Dual-Axis Chart & Chart Configuration Modal Handler
 */

let dualChartInstance = null;

function initDualChart() {
    const chartEl = document.getElementById('dualChart');
    if (!chartEl) return;
    const ctx = chartEl.getContext('2d');
    dualChartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [],
            datasets: [
                {
                    label: '순자산(억)',
                    type: 'line',
                    data: [],
                    borderColor: '#28303dff',
                    backgroundColor: '#28303dff',
                    borderDash: [0, 0],
                    borderWidth: 2,
                    pointBackgroundColor: '#28303dff',
                    pointRadius: 4,
                    yAxisID: 'y1'
                },
                {
                    label: '계좌수',
                    type: 'bar',
                    data: [],
                    backgroundColor: '#60a5fa',
                    borderRadius: 2,
                    yAxisID: 'y2'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    align: 'end',
                    labels: { boxWidth: 10, font: { size: 10 } }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 9 }, color: '#475569' }
                },
                y1: {
                    type: 'linear',
                    position: 'left',
                    title: { display: true, text: '순자산(억)', font: { size: 10 } },
                    ticks: { font: { size: 9 } }
                },
                y2: {
                    type: 'linear',
                    position: 'right',
                    title: { display: true, text: '계좌수', font: { size: 10 } },
                    grid: { display: false },
                    ticks: { font: { size: 9 } }
                }
            }
        }
    });
}

function loadDualChart() {
    const noDataEl = document.getElementById('dualChartNoData');
    fetch('/api/home/chart-data')
        .then(res => res.json())
        .then(data => {
            if (!dualChartInstance) return;
            if (data && data.length > 0) {
                if (noDataEl) noDataEl.style.display = 'none';
                const labels = data.map(item => item.cv2Chtnm || '');
                const netAssets = data.map(item => item.cv2Chtvalue001 || 0);
                const accounts = data.map(item => item.cv2Chtvalue002 || 0);

                dualChartInstance.data.labels = labels;
                dualChartInstance.data.datasets[0].data = netAssets;
                dualChartInstance.data.datasets[1].data = accounts;
            } else {
                if (noDataEl) noDataEl.style.display = 'flex';
                dualChartInstance.data.labels = [];
                dualChartInstance.data.datasets[0].data = [];
                dualChartInstance.data.datasets[1].data = [];
            }
            dualChartInstance.update();
        })
        .catch(err => {
            console.error("Failed to load dual chart data:", err);
            if (noDataEl) noDataEl.style.display = 'flex';
        });
}

function openChartConfigModal() {
    if (!dualChartInstance) return;
    const ds0 = dualChartInstance.data.datasets[0];
    const ds1 = dualChartInstance.data.datasets[1];

    document.getElementById('cfgDs0Type').value = ds0.type || 'line';
    document.getElementById('cfgDs0Color').value = ds0.borderColor || ds0.backgroundColor || '#28303d';
    document.getElementById('cfgDs0Dash').value = (ds0.borderDash && ds0.borderDash[1] > 0) ? 'dashed' : 'solid';
    document.getElementById('cfgDs0Width').value = ds0.borderWidth || 2;

    document.getElementById('cfgDs1Type').value = ds1.type || 'bar';
    document.getElementById('cfgDs1Color').value = ds1.backgroundColor || ds1.borderColor || '#60a5fa';

    // Populate Y-Axis Min/Max
    const y1Min = dualChartInstance.options.scales.y1.min;
    const y1Max = dualChartInstance.options.scales.y1.max;
    const y2Min = dualChartInstance.options.scales.y2.min;
    const y2Max = dualChartInstance.options.scales.y2.max;

    document.getElementById('cfgY1Min').value = (y1Min !== undefined && y1Min !== null) ? y1Min : '';
    document.getElementById('cfgY1Max').value = (y1Max !== undefined && y1Max !== null) ? y1Max : '';
    document.getElementById('cfgY2Min').value = (y2Min !== undefined && y2Min !== null) ? y2Min : '';
    document.getElementById('cfgY2Max').value = (y2Max !== undefined && y2Max !== null) ? y2Max : '';

    document.getElementById('chartConfigModal').style.display = 'flex';
}

function closeChartConfigModal() {
    const modal = document.getElementById('chartConfigModal');
    if (modal) modal.style.display = 'none';
}

function applyChartConfig() {
    if (!dualChartInstance) return;

    const ds0Type = document.getElementById('cfgDs0Type').value;
    const ds0Color = document.getElementById('cfgDs0Color').value;
    const ds0Dash = document.getElementById('cfgDs0Dash').value;
    const ds0Width = parseInt(document.getElementById('cfgDs0Width').value, 10) || 2;

    const ds1Type = document.getElementById('cfgDs1Type').value;
    const ds1Color = document.getElementById('cfgDs1Color').value;

    // Update Dataset 0 (순자산)
    const ds0 = dualChartInstance.data.datasets[0];
    ds0.type = ds0Type;
    if (ds0Type === 'line') {
        ds0.borderColor = ds0Color;
        ds0.backgroundColor = ds0Color;
        ds0.borderDash = (ds0Dash === 'dashed') ? [5, 5] : [0, 0];
        ds0.borderWidth = ds0Width;
        ds0.pointBackgroundColor = ds0Color;
        ds0.pointRadius = 3;
    } else {
        ds0.backgroundColor = ds0Color;
        ds0.borderRadius = 2;
    }

    // Update Dataset 1 (계좌수)
    const ds1 = dualChartInstance.data.datasets[1];
    ds1.type = ds1Type;
    if (ds1Type === 'bar') {
        ds1.backgroundColor = ds1Color;
        ds1.borderRadius = 2;
    } else {
        ds1.borderColor = ds1Color;
        ds1.borderWidth = 2;
        ds1.pointBackgroundColor = ds1Color;
        ds1.pointRadius = 3;
    }

    // Update Y1 Axis Min/Max
    const y1MinVal = document.getElementById('cfgY1Min').value.trim();
    const y1MaxVal = document.getElementById('cfgY1Max').value.trim();
    if (y1MinVal !== '') dualChartInstance.options.scales.y1.min = parseFloat(y1MinVal);
    else delete dualChartInstance.options.scales.y1.min;
    if (y1MaxVal !== '') dualChartInstance.options.scales.y1.max = parseFloat(y1MaxVal);
    else delete dualChartInstance.options.scales.y1.max;

    // Update Y2 Axis Min/Max
    const y2MinVal = document.getElementById('cfgY2Min').value.trim();
    const y2MaxVal = document.getElementById('cfgY2Max').value.trim();
    if (y2MinVal !== '') dualChartInstance.options.scales.y2.min = parseFloat(y2MinVal);
    else delete dualChartInstance.options.scales.y2.min;
    if (y2MaxVal !== '') dualChartInstance.options.scales.y2.max = parseFloat(y2MaxVal);
    else delete dualChartInstance.options.scales.y2.max;

    dualChartInstance.update();
    closeChartConfigModal();
}
