import Qt 4.7
import "scripts/qmlunit.js" as QmlUnit

Item {
    id: testCase

    property string name : 'TestCase'

    function ok(a, msg) {
        QmlUnit.QUnit.ok(a, msg);
    }

    function equals(actual, expected, message) {
        QmlUnit.QUnit.equals(actual, expected, message);
    }

    function same(a, b, message) {
        QmlUnit.QUnit.same(a, b, message);
    }

    function expect(asserts) {
        QmlUnit.QUnit.expect(asserts);
    }

    function stop() {
        QmlUnit.QUnit.stop();
    }

    function start() {
        QmlUnit.QUnit.start();
    }

    function module(name, testEnvironment) {
        QmlUnit.QUnit.module(name, testEnvironment);
    }

    function setTimeout(callback, timeout) {
        var obj = createQmlObject('import Qt 4.7; Timer {running: false; repeat: false; interval: ' + timeout + '}', testCase, "setTimeout");
        obj.triggered.connect(callback);
        obj.running = true;

        return obj;
    }

    function clearTimeout(timer) {
        timer.running = false;
        timer.destroy(1);

        return timer;
    }

    function runTests() {
        var setupAndTeardown = {};

        if (testCase.setup) setupAndTeardown.setup = testCase.setup;
        if (testCase.teardown) setupAndTeardown.teardown = testCase.teardown;

        module(name, setupAndTeardown);

        for (var key in testCase) {
            if (!(key.startsWithAny(['test_', 'asyncTest_']))) continue;

            var parts = key.split('_');

            var testType = parts.shift();

            var expected = parseInt(parts[0], 10);
            if (expected) parts.shift();

            if (expected)
                QmlUnit.QUnit[testType](parts.join(' '), expected, testCase[key]);
            else
                QmlUnit.QUnit[testType](parts.join(' '), testCase[key]);
        }
    }
}