/**
 * Created by everettjf on 15/7/10.
 */
'use strict';

var linkControllers = angular.module('linkControllers',[]);

linkControllers.controller('LinkIndexCtrl',['$scope','$http',function($scope,$http){
    $scope.email = '';
    $scope.password = '';
    $scope.remember = true;
    $scope.hasSession = false;
    $scope.errorMessage = '';

    // check login
    // todo

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
                $scope.hasSession = false;
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

}]);


var logError = function(data,status){
    console.log('code' + status + ':' + data);
};

var serverURL = function(partialURL){
    // return 'http://linkhub.pub' + partialURL;
    return 'http://linkhub.app:8080' + partialURL;
}