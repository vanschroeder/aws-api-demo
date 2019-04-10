<template>
    <form>
        <div v-for="record in values" v-bind:key="record.name" class="form-group">
            <label :for="record.id">{{record.name}}</label>
            <input type="number" :id="record.id" :name="record.id" v-model="record.value"
                   class="form-control" v-on:input="onChange" ref="stepper"/>
        </div>
    </form>
</template>

<script>
    export default {
        name: "inputs-form",
        props: ["values"],
        methods: {
            onChange: function ($event) {
                this.$emit('update', this.values.map((v) => {
                    return Object.defineProperty({}, v.id, {
                        value: v.value,
                        enumerable: true,
                        configurable: true,
                    })
                }));
            },
        },
    };
</script>

<style scoped>
    .form-control {
        margin: 0px 10px;
    }

    label {
        margin: 20px 0px 0px 12px;
    }
</style>
