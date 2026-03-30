import { Chart, registerables, type ChartConfiguration, type DefaultDataPoint } from 'chart.js';

// Register all Chart.js components
Chart.register(...registerables);

// Module color palettes for charts
export const moduleColors = {
  sales: {
    primary: '#EF4444',
    light: '#FEE2E2',
    gradient: ['rgba(239, 68, 68, 0.8)', 'rgba(239, 68, 68, 0.2)'],
  },
  finance: {
    primary: '#6B7280',
    light: '#F3F4F6',
    gradient: ['rgba(107, 114, 128, 0.8)', 'rgba(107, 114, 128, 0.2)'],
  },
  crm: {
    primary: '#10B981',
    light: '#D1FAE5',
    gradient: ['rgba(16, 185, 129, 0.8)', 'rgba(16, 185, 129, 0.2)'],
  },
  hr: {
    primary: '#3B82F6',
    light: '#DBEAFE',
    gradient: ['rgba(59, 130, 246, 0.8)', 'rgba(59, 130, 246, 0.2)'],
  },
  inventory: {
    primary: '#F59E0B',
    light: '#FEF3C7',
    gradient: ['rgba(245, 158, 11, 0.8)', 'rgba(245, 158, 11, 0.2)'],
  },
};

// Common chart options
const commonOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'top' as const,
      labels: {
        usePointStyle: true,
        padding: 16,
        font: {
          family: 'Montserrat',
          size: 12,
        },
      },
    },
  },
  scales: {
    x: {
      grid: {
        display: false,
      },
      ticks: {
        font: {
          family: 'Montserrat',
          size: 11,
        },
      },
    },
    y: {
      grid: {
        color: 'rgba(0, 0, 0, 0.05)',
      },
      ticks: {
        font: {
          family: 'Montserrat',
          size: 11,
        },
      },
    },
  },
};

export interface ChartData {
  labels: string[];
  datasets: {
    label: string;
    data: number[];
    backgroundColor?: string | string[];
    borderColor?: string | string[];
    borderWidth?: number;
    tension?: number;
    fill?: boolean;
  }[];
}

// Create a gradient for the chart
function createGradient(ctx: CanvasRenderingContext2D, colorStart: string, colorEnd: string) {
  const gradient = ctx.createLinearGradient(0, 0, 0, 300);
  gradient.addColorStop(0, colorStart);
  gradient.addColorStop(1, colorEnd);
  return gradient;
}

// Line Chart
export function createLineChart(
  canvasId: string,
  labels: string[],
  datasets: ChartData['datasets'],
  options?: Partial<ChartConfiguration>
): Chart | null {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return null;

  const ctx = canvas.getContext('2d');
  if (!ctx) return null;

  // Apply gradients to datasets
  const enhancedDatasets = datasets.map((dataset, index) => {
    const colors = Object.values(moduleColors);
    const colorSet = colors[index % colors.length];

    return {
      ...dataset,
      backgroundColor: createGradient(ctx, colorSet.gradient[0], colorSet.gradient[1]),
      borderColor: dataset.borderColor || colorSet.primary,
      tension: 0.4,
      fill: true,
    };
  });

  return new Chart(canvas, {
    type: 'line',
    data: { labels, datasets: enhancedDatasets },
    options: {
      ...commonOptions,
      ...options,
    },
  });
}

// Bar Chart
export function createBarChart(
  canvasId: string,
  labels: string[],
  datasets: ChartData['datasets'],
  options?: Partial<ChartConfiguration>
): Chart | null {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return null;

  const colors = Object.values(moduleColors);
  const enhancedDatasets = datasets.map((dataset, index) => {
    const colorSet = colors[index % colors.length];

    return {
      ...dataset,
      backgroundColor: dataset.backgroundColor || colorSet.primary,
      borderColor: dataset.borderColor || colorSet.primary,
      borderWidth: 0,
      borderRadius: 6,
    };
  });

  return new Chart(canvas, {
    type: 'bar',
    data: { labels, datasets: enhancedDatasets },
    options: {
      ...commonOptions,
      ...options,
    },
  });
}

// Doughnut Chart
export function createDoughnutChart(
  canvasId: string,
  labels: string[],
  data: number[],
  backgroundColor?: string[],
  options?: Partial<ChartConfiguration>
): Chart | null {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return null;

  const defaultColors = Object.values(moduleColors).map(c => c.primary);

  return new Chart(canvas, {
    type: 'doughnut',
    data: {
      labels,
      datasets: [{
        data,
        backgroundColor: backgroundColor || defaultColors,
        borderWidth: 0,
        hoverOffset: 8,
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '70%',
      plugins: {
        legend: {
          display: true,
          position: 'bottom' as const,
          labels: {
            usePointStyle: true,
            padding: 16,
            font: {
              family: 'Montserrat',
              size: 12,
            },
          },
        },
      },
      ...options,
    },
  });
}

// Pie Chart
export function createPieChart(
  canvasId: string,
  labels: string[],
  data: number[],
  backgroundColor?: string[],
  options?: Partial<ChartConfiguration>
): Chart | null {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return null;

  const defaultColors = Object.values(moduleColors).map(c => c.primary);

  return new Chart(canvas, {
    type: 'pie',
    data: {
      labels,
      datasets: [{
        data,
        backgroundColor: backgroundColor || defaultColors,
        borderWidth: 0,
        hoverOffset: 8,
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: true,
          position: 'bottom' as const,
          labels: {
            usePointStyle: true,
            padding: 16,
            font: {
              family: 'Montserrat',
              size: 12,
            },
          },
        },
      },
      ...options,
    },
  });
}

// Area Chart (similar to line but with fill)
export function createAreaChart(
  canvasId: string,
  labels: string[],
  datasets: ChartData['datasets'],
  options?: Partial<ChartConfiguration>
): Chart | null {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return null;

  const ctx = canvas.getContext('2d');
  if (!ctx) return null;

  const colors = Object.values(moduleColors);
  const enhancedDatasets = datasets.map((dataset, index) => {
    const colorSet = colors[index % colors.length];

    return {
      ...dataset,
      backgroundColor: createGradient(ctx, colorSet.gradient[0], colorSet.gradient[1]),
      borderColor: dataset.borderColor || colorSet.primary,
      tension: 0.4,
      fill: true,
      pointBackgroundColor: colorSet.primary,
      pointBorderColor: '#fff',
      pointBorderWidth: 2,
      pointRadius: 4,
      pointHoverRadius: 6,
    };
  });

  return new Chart(canvas, {
    type: 'line',
    data: { labels, datasets: enhancedDatasets },
    options: {
      ...commonOptions,
      ...options,
    },
  });
}

// Horizontal Bar Chart
export function createHorizontalBarChart(
  canvasId: string,
  labels: string[],
  datasets: ChartData['datasets'],
  options?: Partial<ChartConfiguration>
): Chart | null {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return null;

  const colors = Object.values(moduleColors);
  const enhancedDatasets = datasets.map((dataset, index) => {
    const colorSet = colors[index % colors.length];

    return {
      ...dataset,
      backgroundColor: dataset.backgroundColor || colorSet.primary,
      borderColor: dataset.borderColor || colorSet.primary,
      borderWidth: 0,
      borderRadius: 6,
    };
  });

  return new Chart(canvas, {
    type: 'bar',
    data: { labels, datasets: enhancedDatasets },
    options: {
      ...commonOptions,
      indexAxis: 'y' as const,
      ...options,
    },
  });
}

// Destroy a chart instance
export function destroyChart(canvasId: string): void {
  const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
  if (!canvas) return;

  const chart = Chart.getChart(canvas);
  if (chart) {
    chart.destroy();
  }
}
