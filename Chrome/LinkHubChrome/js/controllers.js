/**
 * Created by everettjf on 15/7/10.
 */
'use strict';

var linkControllers = angular.module('linkControllers',[]);

linkControllers.controller('LinkIndexCtrl',['$scope','$http',function($scope,$http){
    $scope.email = '';
    $scope.password = '';
    $scope.remember = true;
    $scope.errorMessage = '';

    $scope.hasSession = false;
    $scope.sessionEmail = '';

    var changeToLogoutState = function () {
        $scope.hasSession = false;
        $scope.sessionEmail = '';
    }
    $scope.changeToLogout = function () {
        changeToLogoutState();
    };

    // check login
    $http.post(serverURL('/api/userinfo'),{
        reserved:0
    }).success(function (data, status) {
        if(data.result == 'ok'){
            $scope.sessionEmail = data.email;
            $scope.hasSession = true;
        }
    }).error(function(data,status){
    });

    $scope.login = function () {
        if($scope.email == '' || $scope.password == ''){
            return;
        }

        $http.post(serverURL('/api/login'),{
            email:$scope.email,
            password:$scope.password,
            remember:true
        }).success(function(data,status){
            if(data.result == 'ok'){
                $scope.hasSession = true;
                $scope.errorMessage = '';
            }else{
                changeToLogoutState();
                $scope.errorMessage = '登录出错：' + data.msg;
            }
        }).error(function(data,status){
            logError(data,status);
            $scope.errorMessage = '登录出错：服务器错误';
        });
    };
}]);

linkControllers.controller('LinkSingleCtrl',['$scope','$http',function($scope,$http){

}]);
linkControllers.controller('LinkTabCtrl',['$scope','$http',function($scope,$http){

}]);
linkControllers.controller('LinkMoreCtrl',['$scope','$http',function($scope,$http){
    $scope.logout = function () {
        $http.post(serverURL('/api/logout'),{
            reserved:0
        }).success(function (data, status) {
            if(data.result == 'ok'){
                indexCtrlScope().changeToLogout();
            }
        }).error(function(data,status){
        });
    }
}]);


function indexCtrlScope(){
    return angular.element(document.getElementById('helpForScopeGetter')).scope();
}
var logError = function(data,status){
    console.log('code' + status + ':' + data);
};

var serverURL = function(partialURL){
    // return 'http://linkhub.pub' + partialURL;
    return 'http://linkhub.app:8080' + partialURL;
}