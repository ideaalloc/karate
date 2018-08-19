function() {
    var authorization = karate.get('authorization');
    if (authorization) {
        var uuid = java.util.UUID.randomUUID(); // create a unique id for each request
        // rootBase was available at the time this function was declared
        // and so behaves like a constant, use 'karate.get' for dynamic values
        return {
            Authorization: authorization,
            request_id: uuid + '' // convert the java uuid into a string
        };
    } else {
        return {};
    }
}
