angular.module('')
.controller('homeCtrl', ['$scope', 'adalAuthenticationService','$location', function ($scope, adalService, $location) {
    $scope.login = function () {
        adalService.login();
    };
    $scope.logout = function () {
        adalService.logOut();
    };
    $scope.isActive = function (viewLocation) {        
        return viewLocation === $location.path();
    };
}]);