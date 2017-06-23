(function() {
  'use strict';
var app;

angular.module("SessionsApp",[])
.controller('AutocompleteCtrl', AutocompleteCtrl);

AutocompleteCtrl.$inject = ['$scope'];
function AutocompleteCtrl($scope) {
    $scope.name = "name";

}





// app = angular.module("Sessions", ["ngResource"]);
//
// app.factory("Entry", [
//   "$resource", function($resource) {
//     return $resource("/searches/:id", {
//       id: "@id"
//     }, {
//       update: {
//         method: "PUT"
//       }
//     });
//   }
// ]);
//
// this.RaffleCtrl = [
//   "$scope", "Entry", function($scope, Entry) {
//     $scope.entries = Entry.query();
//     $scope.addEntry = function() {
//       var entry;
//       entry = Entry.save($scope.newEntry);
//       $scope.entries.push(entry);
//       return $scope.newEntry = {};
//     };
//     return $scope.drawWinner = function() {
//       var entry, pool;
//       pool = [];
//       angular.forEach($scope.entries, function(entry) {
//         if (!entry.winner) {
//           return pool.push(entry);
//         }
//       });
//       if (pool.length > 0) {
//         entry = pool[Math.floor(Math.random() * pool.length)];
//         entry.winner = true;
//         entry.$update();
//         return $scope.lastWinner = entry;
//       }
//     };
//   }
// ];
});
