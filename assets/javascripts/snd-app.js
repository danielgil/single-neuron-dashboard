(function () {
    'use strict';
    angular
        .module('snd', ['snd.services', 'snd.directives'])
        .controller('AppListController', ['$rootScope', '$log', '$interval', 'SndService', AppListController])
        .controller('AppDetailController', ['$rootScope', '$log', 'SndService', AppDetailController]);

    /**
     *
     * @param $rootScope
     * @param $scope
     * @param $http
     * @param $log
     * @param $interval
     * @param AppService
     * @constructor
     */
    function AppListController($rootScope, $log, $interval, SndService) {
        /* jshint validthis: true */
        var vm = this;
        //Global variables
        $rootScope.currentApp = {};//selected app
        $rootScope.apps = {};//list of apps

        SndService.getAppList().then(function(data){
            $rootScope.apps = data.data;
        });

        vm.selectApp = function (appName) {
            $rootScope.currentApp = findAppByName($rootScope.apps, appName);
            $rootScope.currentApp.selected = true;
        };

        vm.init = function () {
            this.setWatchAppStatus();
        };

        vm.setWatchAppStatus = function () {
            $interval(function () {
                //$scope.watchAppStatus();
            }, 2000);
        };

        vm.watchAppStatus = function () {
            for (count = 0; count <= 2; count++) {

            }
        };

        vm.startFirstApp = function(appName){
            SndService.startApp(appName);
        }
    }

    /**
     *
     * @param $rootScope
     * @param $scope
     * @param $http
     * @param $log
     * @param AppService
     * @constructor
     */
    function AppDetailController($rootScope, $log, SndService) {
        this.startApp = function (appName) {
            SndService.startApp(appName).then(function (data){
                $log.log('Starting app ' + appName + ': ' + data.data.status);
                $rootScope.currentApp.current_status = 'running';
            });
        };
        this.stopApp = function (appName) {
            SndService.stopApp(appName).then(function (data){
                $log.log('Stopping app ' + appName + ': ' + data.data.status);
                $rootScope.currentApp.current_status = 'stopped';
            });
        };
        this.getAppStatus = function (appName) {
            SndService.getAppStatus(appName).then(function (data){
                $log.log('Getting status of app ' + appName + ': ' + data.data.status);
                $rootScope.currentApp.current_status = getStatusLabel(data.data.status);
            });
        };
        this.getAppVersion = function () {
            SndService.getAppVersion(appName).then(function (data){
                $log.log('Getting version of app ' + appName + ': ' + data.data.status);
                $rootScope.currentApp.current_version = data.data.version;
            });
        };
        this.getAppVersionList = function () {
            SndService.getAppVersionList(appName).then(function (data){
                $log.log('Getting version list of app ' + appName + ': ' + data.data.status);
                $rootScope.currentApp.available_versions = data.data.available_versions;
            });
        };
        this.deployApp = function () {
            SndService.deployApp(appName).then(function (data){
                $log.log('Deploying app ' + appName + ': ');
            });
        };
        this.logApp = function () {
            SndService.getAppVersionList(appName).then(function (data){
                $log.log('Getting log of app ' + appName + ': ');
            });
        };
        this.exportApp = function () {
            SndService.exportAppLog(appName).then(function (data){
                $log.log('Explorting log of app ' + appName + ': ');
            });
        };
    }

    /**
     *
     * @param array
     * @param name
     * @returns {*}
     */
    function findAppByName(array, name) {
        var result = $.grep(array, function (e) {
            return e.name == name;
        });

        return (result.length > 0) ? result[0] : undefined;
    }

    /**
     *
     * @param label
     * @returns {*}
     */
    function getStatusLabel(label) {
        switch (label.toLowerCase()) {
            case 'application already running':
                return 'running';
            case 'command not available':
                return undefined;
            case 'success':
                return 'running';
            default:
                return label;
        }
    }

})();