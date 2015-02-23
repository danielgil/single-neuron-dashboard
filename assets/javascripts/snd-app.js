var sndapp = angular.module('sndapp', []);

sndapp.controller('ListController', ['$scope', '$http', function ($scope, $http) {
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
                changeCurrentAppStatus(data, $scope.apps, appName);
            }).error(function (data) {
                alert('Error starting app...');
            });
    };
    $scope.stopApp = function (appName) {
        $http.get('/stop/' + appName)
            .success(function (data) {
                changeCurrentAppStatus(data, $scope.apps, appName);
            }).error(function (data) {
                alert('Error stopping app...');
            });
    };
    $scope.getAppStatus = function (appName) {
        $http.get('/status/' + appName)
            .success(function (data) {
                changeCurrentAppStatus(data, $scope.apps, appName);
            }).error(function (data) {
                alert('Error getting status app...');
            });
    };
    $scope.deployApp = function (appName) {
        $http.get('/deploy/' + appName)
            .success(function (data) {
                changeCurrentAppStatus(data, $scope.apps, appName);
            }).error(function (data) {
                alert('Error deploying app...');
            });
    };
    $scope.logApp = function (appName) {
        $http.get('/log/' + appName)
            .success(function (data) {
                changeCurrentAppStatus(data, $scope.apps, appName);
            }).error(function (data) {
                alert('Error Logging app...');
            });
    };
    $scope.exportApp = function (appName) {
        $http.get('/export/' + appName)
            .success(function (data) {
                changeCurrentAppStatus(data, $scope.apps, appName);
            }).error(function (data) {
                alert('Error Exporting app...');
            });
    };

}]);

function changeCurrentAppStatus(data, apps, appName){
    var status = getCurrentStatus(data);                //we transform the message in a proper status class-name
    var appObject = findAppByName(apps, appName);//we look for the app object with that name
    appObject[0].status = status;                       //we modify the status value of that app
}

function findAppByName(array, name){
    var result = $.grep(array, function(e){ return e.name == name; });

    return result;
}
function getCurrentStatus(status){
    var result;
    switch (status.status){
        case 'Failure': result = 'failure';
            break;
        case 'Success': result = 'success';
            break;
        case 'Application already running': result = 'running';
            break;
        case 'Application already stopped': result = 'stopped';
            break;
        case 'Command not available': result = 'error';
            break;
    }

    return result;
}