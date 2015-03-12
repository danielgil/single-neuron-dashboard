(function () {
    'use strict';
    angular
        .module('snd.services', ['ngResource'])
        .factory('SndService', ['$http', '$log', SndService]);

    /**
     *
     * @param $http
     * @param $log
     * @returns {{getAppList: Function, startApp: Function, stopApp: Function, getAppStatus: Function, getAppVersion: Function, getAppVersionList: Function, deployApp: Function, exportAppLog: Function, getAppLog: Function}}
     * @constructor
     */

    function SndService($http, $log) {

        return {
            getAppList: function(){
                var promise = $http.get('/list')
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        alert('Error getting list of apps...');
                    });
                return promise;
            },
            startApp: function (appName) {
                var promise = $http.get('/start/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error starting app ' + appName);
                    });
                return promise;
                },
            stopApp: function (appName) {
                var promise = $http.get('/stop/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error stopping app ' + appName);
                    });
                return promise;
            },
            getAppStatus: function (appName) {
                var promise = $http.get('/status/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error getting app status of ' + appName);
                    });
                return promise;
            },
            getAppVersion: function (appName) {
                return $http.get('/version/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error getting app version of ' + appName);
                    });
                return promise;
            },
            getAppVersionList: function (appName) {
                var promise = $http.get('/list/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error getting app list of versions of ' + appName);
                    });
                return promise;
            },
            deployApp: function (appName) {
                var promise = $http.get('/deploy/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error deploying app ' + appName);
                    });
                return promise;
            },
            exportAppLog: function (appName) {
                var promise = $http.get('/export/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error exporting log app of ' + appName);
                    });
                return promise;
            },
            getAppLog: function (appName) {
                var promise = $http.get('/log/' + appName)
                    .success(function (data) {
                        return data;
                    }).error(function (data) {
                        $log.info('Error getting app log of ' + appName);
                    });
                return promise;
            }
        }
    }
})();
//
//this.findJobDetails = function (jobId) {
//    var promise = $http.get(jobsUrl + '/' + jobId).
//        success(function (data, status, headers, config, statusText) {
//            return data;
//        }).
//        error(function (data, status, headers, config, statusText) {
//            $log.error("Error while retrieving job details from REST service: " + data);
//            throw data;
//        });
//    return promise;
//}
//
//jobiqExceptions.factory('$exceptionHandler', ['$injector', handleException]);
//
//function handleException($injector) {
//    return function (exception, cause) {
//
//
//        var windowService = $injector.get('$window');
//        locationService.path('error/' + errorMessage);
//
//
//        var locationService = $injector.get('$location');