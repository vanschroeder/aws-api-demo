const _handler = require("../../index")();
const increment = process.env.INCREMENT ? parseInt(process.env.INCREMENT, 10) : 0;

/**
 * lambda request handling logic
 */
_handler.subscribe((lambdaRequestData) => {
    const _q = lambdaRequestData.toJSON().queryStringParameters;
    _handler.response = {
        body: JSON.stringify(Object.keys(_q)
            .map((k) => Object.assign(_q,
                Object.defineProperty({}, k, {
                    value: parseInt(_q[k], 10) + increment,
                    enumerable: true,
                    configurable: true,
                })
            ))
            .reduce((a, b) => {
                const _key = Object.keys(a)[0];
                return Object.defineProperty(b, _key, {
                    value: a[_key],
                    enumerable: true,
                    configurable: true,
                });
            })
        ),
    };
});

exports.handler = _handler();
