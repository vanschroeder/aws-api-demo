<template>
    <div id="chartDiv" ref="chartdiv"></div>
</template>

<script>
    import * as am4core from "@amcharts/amcharts4/core";
    import * as am4charts from "@amcharts/amcharts4/charts";
    import am4themes_animated from "@amcharts/amcharts4/themes/animated";

    am4core.useTheme(am4themes_animated);

    /**
     * BarChart Component
     */
    export default {
        name: "bar-chart",
        props: ["values"],
        /**
         * Configures and Creates Chart
         */
        mounted() {
            this.createChart();
        },
        watch: {
            values: function(newVal) {
                this.renderChart(newVal);
            },
        },
        methods: {
            createChart: function() {
                this.chart = am4core.create(this.$refs.chartdiv, am4charts.XYChart3D);
                this.chart.paddingRight = 20;

                // Create axes
                var categoryAxis = this.chart.yAxes.push(new am4charts.CategoryAxis());
                categoryAxis.dataFields.category = "name";
                categoryAxis.renderer.inversed = true;

                this.renderChart(this.values);
            },
            /**
             *
             */
            renderChart: function(d) {
                ['xAxes', 'series'].forEach((x) => {
                    if (this.chart[x].length) {
                        this.chart[x].shift();
                    }
                });

                this.chart.data = d.map((r) => Object.assign(r, {
                    color: r.color || this.chart.colors.next(),
                }));

                if (this.chart.data.length) {
                    // var valueAxis =
                    this.chart.xAxes.push(new am4charts.ValueAxis());

                    // Create series
                    var series = this.chart.series.push(new am4charts.ColumnSeries3D());
                    series.dataFields.valueX = "value";
                    series.dataFields.categoryY = "name";
                    series.name = "Value";
                    series.columns.template.propertyFields.fill = "color";
                    series.columns.template.tooltipText = "{valueX}";
                    series.columns.template.column3D.stroke = am4core.color("#fff");
                    series.columns.template.column3D.strokeOpacity = 0.2;
                }
            },
        },

        /**
         * disposes of Chart for gc before destroying instance
         */
        beforeDestroy() {
            if (this.chart) {
                this.chart.dispose();
            }
        }
    }
    ;
</script>

<style scoped>
    h3 {
        margin: 40px 0 0;
    }

    ul {
        list-style-type: none;
        padding: 0;
    }

    li {
        display: inline-block;
        margin: 0 10px;
    }

    a {
        color: #42b983;
    }

    #chartDiv {
        min-height: 350px;
    }
</style>
