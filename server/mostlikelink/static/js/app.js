

function serverUrl(partialUrl){
    return baseUrl + partialUrl;
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

mostlikelinkApp.controller('mostlikelinkCtrl',['$scope','$http','$window',function($scope,$http,$window){
    if(blogId == undefined){
        clog('return when undefined');
        return;
    }

    $scope.allTags = [];
    $scope.allTopics = [];
    $scope.filterTags = [];

    $scope.topLinks = [];

    $scope.allLinks = [];
    $scope.mostClickLinks = [];
    $scope.latestClickLinks = [];
    $scope.neverClickLinks = [];

    var refreshPage = function () {
        $http.post(serverUrl('api/blog/index'), {
            blog_id: blogId,
            filter_tags: $scope.filterTags
        }).success(function (data, status) {
            if(data.succeed){
                $scope.topLinks = data.top_links;

                $scope.allTags = data.all_tags;
                $scope.allTopics = data.all_topics;

                $scope.allLinks = data.all_links;
                $scope.mostClickLinks = data.most_click_links;
                $scope.latestClickLinks = data.latest_click_links;
                $scope.neverClickLinks = data.never_click_links;
            }else{
                clog(data.reason);
            }
        }).error(function(data,status){
        });
    };

    refreshPage();

    $scope.clickLink = function (link) {
        clog(link.title);
        $window.open(link.url, '_blank');

        $http.post(serverUrl('api/blog/link/click'),{
            blog_id:blogId,
            link_id:link.id
        }).success(function (data, status) {
            clog('click = ' + data.succeed);
        }).error(function (data, status) {
        });
    };

    $scope.addFilterTag = function (tag) {
        for(var i=0;i<$scope.filterTags.length;++i){
            if($scope.filterTags[i].id==tag.id){
                return;
            }
        }

        $scope.filterTags.push(tag);
        clog($scope.filterTags);
        refreshPage();
    };
    $scope.removeFilterTag = function (tag) {
        $scope.filterTags.pop(tag);
        clog($scope.filterTags);
        refreshPage();
    };

    $scope.clearFilterTag = function () {
        $scope.filterTags=[];
        refreshPage();
    };

}]);
