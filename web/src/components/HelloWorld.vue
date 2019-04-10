<template>
    <div class="hello">
        <h1>{{ msg }}</h1>
        <div id="chartDiv" ref="chartdiv"></div>
    </div>
</template>

<script>
    import * as am4core from "@amcharts/amcharts4/core";
    import * as am4charts from "@amcharts/amcharts4/charts";
    import am4themes_animated from "@amcharts/amcharts4/themes/animated";

    am4core.useTheme(am4themes_animated);

    export default {
        name: 'HelloWorld',
        props: {
            msg: String,
        },
        mounted() {
            let chart = am4core.create(this.$refs.chartdiv, am4charts.XYChart3D);

            chart.paddingRight = 20;

            chart.data = [{
                "input": 1,
                "value": 23.5,
                "color": chart.colors.next()
            }, {
                "input": 2,
                "value": 26.2,
                "color": chart.colors.next()
            }, {
                "input": 3,
                "value": 30.1,
                "color": chart.colors.next()
            }, {
                "input": 4,
                "value": 29.5,
                "color": chart.colors.next()
            }, {
                "input": 5,
                "value": 24.6,
                "color": chart.colors.next()
            }];

            // Create axes
            var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "input";
            categoryAxis.numberFormatter.numberFormat = "#";
            categoryAxis.renderer.inversed = true;

            var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());

// Create series
            var series = chart.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueX = "value";
            series.dataFields.categoryY = "input";
            series.name = "Value";
            series.columns.template.propertyFields.fill = "color";
            series.columns.template.tooltipText = "{valueX}";
            series.columns.template.column3D.stroke = am4core.color("#fff");
            series.columns.template.column3D.strokeOpacity = 0.2;
        },

        beforeDestroy() {
            if (this.chart) {
                this.chart.dispose();
            }
        }

    }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
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
