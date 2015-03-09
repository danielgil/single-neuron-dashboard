var sndapp = angular.module('sndapp', []);

sndapp.controller('ListController', ['$scope', '$http', function ($scope, $http) {
    $scope.currentApp = {
        name: undefined,
        status: undefined,
        version: undefined,
        versionList: undefined,
        enabled: false
    };

    $scope.selectApp = function (appName){
        var appObject = findAppByName($scope.apps, appName);
        $scope.currentApp.name = appName;
        $scope.currentApp.enabled = true;
        $scope.currentApp.version = '3.0';
        $scope.currentApp.options = appObject.options;
        $scope.getAppStatus(appName);
        //$scope.getAppVersion(appName);
        $scope.getAppVersionList(appName);
    },

    $scope.getList = function () {
        $http.get('/list')
            .success(function (data) {
                $scope.apps = data;
            }).error(function (data) {
                alert('Error getting list of apps...');
            });
    };
    $scope.startApp = function (appName) {
        $http.get('/start/' + appName)
            .success(function (data) {
                $scope.getAppStatus(appName);
            }).error(function (data) {
                $scope.getAppStatus(appName);
            });
    };
    $scope.stopApp = function (appName) {
        $http.get('/stop/' + appName)
            .success(function (data) {
                console.log('Getting status');
                $scope.getAppStatus(appName);
            }).error(function (data) {
                $scope.getAppStatus(appName);
            });
    };
    $scope.getAppStatus = function (appName) {
        $http.get('/status/' + appName)
            .success(function (data) {
                console.log('Getting status');
                $scope.currentApp.status = getCurrentStatus(data);
            }).error(function (data) {
                alert('Error getting status app...');
            });
    };
    $scope.getAppVersion = function (appName) {
        $http.get('/version/' + appName)
            .success(function (data) {
                $scope.currentApp.version = data.version;
            }).error(function (data) {
                alert('Error getting version of app...');
            });
    };
    $scope.getAppVersionList = function (appName) {
        $http.get('/list/' + appName)
            .success(function (data) {
                $scope.currentApp.versionList = data.versions;
            }).error(function (data) {
                alert('Error getting list of versions of app...');
            });
    };
    $scope.deployApp = function (appName) {
        $http.get('/deploy/' + appName)
            .success(function (data) {
                alert('Deploying app ' + appName);
            }).error(function (data) {
                alert('Error deploying app...');
            });
    };
    $scope.logApp = function (appName) {
        $http.get('/log/' + appName)
            .success(function (data) {
                alert('Logging app ' + appName);
            }).error(function (data) {
                alert('Error Logging app...');
            });
    };
    $scope.exportApp = function (appName) {
        $http.get('/export/' + appName)
            .success(function (data) {
                alert('Exporting app ' + appName);
            }).error(function (data) {
                alert('Error Exporting app...');
            });
    };


}]);



function changeCurrentAppStatus(data, apps, appName){
    var status = getCurrentStatus(data);                //we transform the message in a proper status class-name
    var appObject = findAppByName(apps, appName);//we look for the app object with that name
    appObject.status = status;                       //we modify the status value of that app
}

function getCurrentVersion(data, apps, appName){
    var appObject = findAppByName(apps, appName);//we look for the app object with that name
    appObject.version = data;                       //we modify the status value of that app
}

function getListOfVersions(data, apps, appName){
    var appObject = findAppByName(apps, appName);//we look for the app object with that name
    appObject.versionList = data;
}

function findAppByName(array, name){
    var result = $.grep(array, function(e){ return e.name == name; });

    return (result.length > 0) ? result[0] : undefined;
}
function getCurrentStatus(status){
    var result;
    switch (status.status){
        case 'Running': result = 'running';
            break;
        case 'Stopped': result = 'stopped';
            break;
    }

    return result;
}