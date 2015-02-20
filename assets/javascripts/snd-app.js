/**
 * Created by pabloserrano on 20/02/15.
 */
angular.module('single-neuron-app', [])
    .controller('TodoController', ['$scope', function($scope){
        $scope.todos = [
            {text: 'Primer elemento', done: true},
            {text: 'Segundo elemento', done: false},
        ];
        $scope.remaining = function(){
            var count = 0;
            angular.forEach($scope.todos, function(todo){
                count += todo.done ? 0 : 1;
            });
        };
        $scope.addTodo = function(){
            $scope.todos.push({text:$scope.todoText, done: false});
            $scope.todoText = '';
        };
        $scope.archive = function(){
            var oldTodos = $scope.todos;
            $scope.todos = [];
            angular.forEach(oldTodos, function(todo){
                if(!todo.done) $scope.todos.push(todo);
            });
        };

    }]);