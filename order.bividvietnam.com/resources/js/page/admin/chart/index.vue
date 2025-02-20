<template>
    <div>
      <h4 class="fw-bold py-3 mb-2">
        <span class="text-muted fw-light">Biểu đồ <i class="bx bx-chevron-right" style="font-size: 40px;"></i></span> Lọc danh sách
      </h4>
      <div class="d-flex align-items-center justify-content-between col-md-5">
        <div class="mb-3 row">
          <label for="html5-year-input" class="col-md-2 col-form-label">Năm</label>
          <div class="col-md-10">
            <input class="form-control" type="number" v-model="selectedYear" @input="updateChart" />
          </div>
        </div>
        <div class="mb-3 row">
          <label for="html5-month-input" class="col-md-2 col-form-label">Tháng</label>
          <div class="col-md-10">
            <input class="form-control" type="number" v-model="selectedMonth" @input="updateChart" />
          </div>
        </div>
      </div>
      <canvas ref="chartCanvas"></canvas>
    </div>
  </template>
  <script>
  import axios from "axios";
  import { inject } from "vue";
  export default {
    data() {
      return {
        chart: null,
        errored: false,
        selectedYear: null,
        selectedMonth: null,
        chartData: [],
      };
    },
    mounted() {
      this.fetchChartData();
    },
    methods: {
      fetchChartData() {
        const globalState = inject("globalState");
        const baseUrl = globalState.baseUrl;
        axios
          .get(`${baseUrl}/api/chart/create`)
          .then((response) => {
            this.chartData = response.data.data;
            this.createChart(this.chartData);
          })
          .catch((error) => {
            console.error(error);
            this.errored = true;
          });
      },
      createChart(chartData) {
        const chartCanvas = this.$refs.chartCanvas;
        const ctx = chartCanvas.getContext("2d");

        if (this.chart) {
          this.chart.destroy();
        }
        let filteredChartData = chartData;
        if (this.selectedYear) {
          filteredChartData = filteredChartData.filter((item) => item.year === this.selectedYear);
        }
        if (this.selectedMonth) {
          filteredChartData = filteredChartData.filter((item) => item.month === this.selectedMonth);
        }
        const labels = filteredChartData.map((item) => `${item.year}-${item.month}`);
        const data = filteredChartData.map((item) => item.total_price);
        this.chart = new Chart(ctx, {
          type: "bar",
          data: {
            labels: labels,
            datasets: [
              {
                label: "Total Price",
                data: data,
                borderWidth: 1,
              },
            ],
          },
          options: {
            scales: {
              y: {
                beginAtZero: true,
              },
            },
          },
        });
      },
      updateChart() {
        this.createChart(this.chartData);
      },
    },
  };
  </script>
  <style>
  .chart-container {
    text-align: center;
  }
  </style>
