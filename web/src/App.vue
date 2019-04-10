<template>
    <div id="app">
        <div class="row justify-content-center">
            <div class="col-3">
                <inputs-form v-bind:values="data" v-on:update="onInputUpdate"></inputs-form>
            </div>
            <div class="col-7">
                <bar-chart v-bind:values="data"></bar-chart>
            </div>
        </div>
    </div>
</template>

<script>
    import BarChart from './components/BarChart'
    import InputsForm from './components/InputsForm'
    import Vue from 'vue'
    import axios from 'axios'
    import VueAxios from 'vue-axios'
    import BootstrapVue from 'bootstrap-vue'
    import 'bootstrap/dist/css/bootstrap.css'
    import 'bootstrap-vue/dist/bootstrap-vue.css'

    Vue.use(BootstrapVue, VueAxios, axios);

    const __API_URL__ = "https://7ef47g5kpi.execute-api.us-east-1.amazonaws.com/api-demo/get-values";

    export default {
        name: 'app',
        data() {
            let _cnt = 0;
            return {
                data: [1,2,3,4,5].map((x) => {
                    return {
                        id: `input${x}`, name: `Input ${x}`, value: Math.round(100 * Math.random())
                    };
                })
            };
        },
        methods: {
            onInputUpdate: function (d) {
                if (!d.length) {
                    return;
                }

                const _q = d.map((x) => `${Object.keys(x)[0]}=${x[Object.keys(x)[0]]}`)
                    .reduce((a, b) => `${a !== "" ? `${a}&` : ""}${b}`, "");

                const _self = this;
                axios.post(`${__API_URL__}?${_q}`, {}).then(
                    function (response) {
                        _self.data = Object.keys(response.data).map(
                            function (k) {
                                const _idx = _self.data.findIndex((x) => x.id === k);
                                return Object.assign(_self.data[_idx], {value: response.data[k]});
                            });
                    }
                );
            },
        },
        components: {
            BarChart,
            InputsForm
        }
    }
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        color: #2c3e50;
        margin-top: 60px;
        font-weight: lighter !important;
    }
</style>
