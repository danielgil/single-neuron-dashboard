angular.module('sndapp', [])
    .controller('ListController', ['$scope', function ($scope) {
        $scope.apps = [
            {name: 'SkyeApp', status: true},
            {name: 'SkyeUm', status: false}
        ];
        $scope.giveList = function () {
            alert('Giving');
        };

    }]);