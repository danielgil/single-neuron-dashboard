(function () {
    'use strict';
    angular
        .module('snd.directives', [])
        .directive('appItem', appItemDirective)
        .directive('appItemSelected', appItemSelectedDirective);

    function appItemDirective(){
        return {
            restrict: 'E',
            templateUrl: 'app-item.html'
        };
    }
    function appItemSelectedDirective(){
        return {
            restrict: 'E',
            templateUrl: 'app-item-selected.html'
        };
    }
})();