const {RxVO} = require("rxvo");
const {JSONSchemaDraft04, ELBRequestSchema, ELBResponseSchema} = require("./lib/schemas");
/**
 * pre-fab Lambda response object
 * @type {*}
 */
const EmptyResponseObject = {
    statusCode: 200,
    headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
    },
    body: "",
    isBase64Encoded: false,
};

/**
 * Lambda request handler
 */
const _intake = new RxVO({
    meta: [JSONSchemaDraft04],
    schemas: [ELBRequestSchema],
});

/**
 * Lambda response handler
 */
const _output = new RxVO({
    meta: [JSONSchemaDraft04],
    schemas: [ELBResponseSchema],
});

const _send = (r) => {
    _output.model = r;
};

/**
 * @returns {function}
 */
module.exports = () => {
    const handler = () => {
        return async (event) => {
            return new Promise((resolve, reject) => {
                const _sub = _output.subscribe({
                    next: (response) => {
                        response = response.toJSON();
                        _sub.unsubscribe();
                        if (response.statusCode >= 400) {
                            reject(response);
                            throw response;
                        }

                        resolve(response);
                    },
                    error: (e) => {
                        _sub.unsubscribe();
                        const _e = {
                            statusCode: 400,
                            body: JSON.stringify(e,null,2),
                        };

                        reject(_e);
                        throw _e;
                    },
                });
                _intake.model = event;
            });
        };
    };

    // response setter
    Object.defineProperty(handler, "response", {
        set: (data) => _send(Object.assign(EmptyResponseObject, data)),
        enumerable: true,
        configurable: false,
    });

    Object.defineProperty(handler, "subscribe", {
        value: (handler) => _intake.subscribe(handler),
        enumerable: true,
        configurable: false,
    });

    // returns `promise` which resolves with rxjs observer
    return handler;
};
