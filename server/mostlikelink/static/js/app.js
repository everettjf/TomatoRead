

function serverUrl(partialUrl){
    return 'http://0.0.0.0:5000/' + partialUrl;
}

function logInfo(prefix,content){
    console.log(prefix + '|' + content);
}

var clog=function(content){
    logInfo('user',content);
};
var mostlikelinkApp = angular.module('mostlikelinkApp',[]);

mostlikelinkApp.config(['$interpolateProvider', function($interpolateProvider) {
  $interpolateProvider.startSymbol('[[');
  $interpolateProvider.endSymbol(']]');
}]);

mostlikelinkApp.controller('mostlikelinkCtrl',['$scope','$http',function($scope,$http){
    clog('blog id = ' + blog_id);

    $scope.allTags = [];
    $scope.filterTags = [];

    $scope.allLinks = [];
    $scope.topClickLinks = [];
    $scope.neverClickLinks = [];
    $scope.recentClickLinks = [];

    $http.post(serverUrl('api/blog/index'), {
        blog_id: blog_id
    }).success(function (data, status) {
        if(data.succeed){
            $scope.allTags = data.all_tags;
            $scope.allLinks = data.all_links;
        }else{
            clog(data.reason);
        }
    }).error(function(data,status){
    });

}]);
