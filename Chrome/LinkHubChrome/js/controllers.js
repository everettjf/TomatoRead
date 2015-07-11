/**
 * Created by everettjf on 15/7/10.
 */
'use strict';

var linkControllers = angular.module('linkControllers',[]);

linkControllers.controller('LinkIndexCtrl',['$scope','$http',function($scope,$http){
    console.log('controller index');
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

    $scope.openTab = function(fullURL) {
        chrome.tabs.create({
            url: fullURL
        }, function (tab) {
        });
    }
}]);

var linkSingleScope = null;
linkControllers.controller('LinkSingleCtrl',['$scope','$http',function($scope,$http){
    console.log('controller single');
    linkSingleScope = $scope;
    $scope.okMsg = '';
    $scope.errorMsg = '';

    getCurrentTabUrl(function(title,url) {
        var $scope = linkSingleScope;

        $scope.name = title;
        $scope.url = url;
        $scope.tags = '';
        $scope.$apply();
    });

    $scope.saveLink = function () {
        if($scope.name == '' || $scope.url == ''){
            return;
        }

        $http.post(serverURL('/api/savelink'),{
            name:$scope.name,
            url:$scope.url,
            tags:$scope.tags
        }).success(function (data, status) {
            if(data.result='ok'){
                $scope.okMsg = '已收藏';
            }else{
                $scope.errorMsg = '收藏出错';
            }
        }).error(function (data, status) {
            $scope.errorMsg = '收藏出错：服务器错误';
        });
    };


}]);

var linkTabScope = null;
linkControllers.controller('LinkTabCtrl',['$scope','$http',function($scope,$http){
    console.log('controller tab');
    linkTabScope = $scope;

    $scope.links = [];
    $scope.okMsg = '';
    $scope.errorMsg = '';


    getAllTabUrl(function (links) {
        var $scope = linkTabScope;
        $scope.links = links;
        $scope.$apply();
    });

    $scope.saveTabLink = function () {
        if($scope.links.length == 0){
            return;
        }

        $http.post(serverURL('/api/savelinkbatch'),{
            links:$scope.links
        }).success(function (data, status) {
            if(data.result == 'ok'){
                $scope.okMsg = '已收藏';
            }else{
                $scope.errorMsg = data.msg;
            }
        }).error(function (data, status) {
            $scope.errorMsg = '保存出错：服务器错误';
        });
    }
}]);
linkControllers.controller('LinkMoreCtrl',['$scope','$http',function($scope,$http){
    console.log('controller more');

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

function getCurrentTabUrl(callback) {
    var queryInfo = {
        active: true,
        currentWindow: true
    };

    chrome.tabs.query(queryInfo, function(tabs) {
        var tab = tabs[0];

        var url = tab.url;
        var title = tab.title;

        console.assert(typeof url == 'string', 'tab.url should be a string');
        console.assert(typeof title == 'string', 'tab.title should be a string');

        callback(title,url);
    });
}

function getAllTabUrl(callback){
    var queryInfo = {
        currentWindow: true
    };

    chrome.tabs.query(queryInfo, function(tabs) {
        var links = [];
        for(var index in tabs){
            var tab = tabs[index];
            var url = tab.url;
            var name = tab.title;
            links.push({
                name:name,
                url:url,
                tags:''
            });
        }
        console.log(links);
        callback(links);
    });
}

angular.element(document).ready(function() {
    console.log('dom content loaded');
});
