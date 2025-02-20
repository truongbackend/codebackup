<template>
    <div>
      <h4 class="fw-bold py-3 mb-2">
        <span class="text-muted fw-light">Biểu đồ <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> So sánh
      </h4>
      <div class="d-flex align-items-center justify-content-between col-md-5">
        <div class="mb-3 row">
          <label for="selected-year-input" class="col-md-2 col-form-label">Năm</label>
          <div class="col-md-10">
            <input class="form-control" type="number" id="selected-year-input" v-model="selectedYear" @input="updateChart" />
          </div>
        </div>
      </div>
      <canvas ref="chartCanvas"></canvas>
    </div>
  </template>

  <script>
  import axios from "axios";

  export default {
    data() {
      return {
        chart: null,
        errored: false,
        selectedYear: null,
        chartData: [],
      };
    },
    mounted() {
      this.fetchChartData();
    },
    methods: {
      fetchChartData() {
        axios
          .get(`/api/chart/create`)
          .then((response) => {
            this.chartData = response.data.data;
            this.updateChart();
          })
          .catch((error) => {
            console.error(error);
            this.errored = true;
          });
      },
      createChart(labels, datasets) {
        const chartCanvas = this.$refs.chartCanvas;
        if (chartCanvas) {
          const ctx = chartCanvas.getContext("2d");

          if (this.chart) {
            this.chart.destroy();
          }

          this.chart = new Chart(ctx, {
            type: "bar",
            data: {
              labels: labels,
              datasets: datasets,
            },
            options: {
              scales: {
                y: {
                  beginAtZero: true,
                },
              },
            },
          });
        }
      },
      updateChart() {
        if (this.selectedYear) {
          const selectedYear = parseInt(this.selectedYear);
          const currentYear = new Date().getFullYear();
          const labels = [];
          const datasetsSelectedYear = [];
          const datasetsCurrentYear = [];

          for (let month = 1; month <= 12; month++) {
            labels.push(`Tháng ${month}`);

            const datasetSelectedYear = this.getDataForMonthYear(month, selectedYear);
            datasetsSelectedYear.push(datasetSelectedYear);

            const datasetCurrentYear = this.getDataForMonthYear(month, currentYear);
            datasetsCurrentYear.push(datasetCurrentYear);
          }

          const datasets = [
            {
              label: `Năm ${selectedYear}`,
              data: datasetsSelectedYear,
              backgroundColor: `rgba(255, 99, 132, 0.5)`,
              borderColor: `rgba(255, 99, 132, 1)`,
              borderWidth: 1,
            },
            {
              label: `Năm ${currentYear}`,
              data: datasetsCurrentYear,
              backgroundColor: `rgba(54, 162, 235, 0.5)`,
              borderColor: `rgba(54, 162, 235, 1)`,
              borderWidth: 1,
            },
          ];

          this.createChart(labels, datasets);
        }
      },
      getDataForMonthYear(month, year) {
        const monthData = this.chartData.find(
          (item) => item.year === year && item.month === month
        );
        return monthData ? monthData.total_price : 0;
      },
    },
  };
  </script>

  <style>
  .chart-container {
    text-align: center;
  }
  </style>
