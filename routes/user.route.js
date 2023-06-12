const route=require('express').Router();
const UserController=require("../controller/user.controller");
const PopularFoodMianController=require("../controller/popularfoodmainpage.controller");
const PopularProductMianController=require("../controller/popularprodutmain.controller");
const RestaurantController=require("../controller/restaurantcontroller");
const FoodController=require("../controller/food.controller");
const CategoryController=require("../controller/category.controller");
const CartHistoryController=require('../controller/cartHistory.controller');
const PastSearchesConstroller=require('../controller/pastsearches.controller');


route.post('/register',UserController.register);
route.post('/login',UserController.login);
route.post('/uploadPFM',PopularFoodMianController.upload);
route.get('/uploadPFM', PopularFoodMianController.download);
route.post('/uploadPPM',PopularProductMianController.upload);
route.get('/uploadPPM', PopularProductMianController.download);
route.post('/restaurant',RestaurantController.postData);
route.get('/restaurant',RestaurantController.getData);
route.post('/restaurant1',RestaurantController.getData1);
route.post('/restaurant2',RestaurantController.getData2);
route.post('/searchRes',RestaurantController.search);
route.post('/food',FoodController.postData);
route.post('/food1',FoodController.getData);
route.post('/searchFood',FoodController.search);
route.post('/category',CategoryController.postData);
route.get('/category',CategoryController.getData);
route.post('/cartHistory',CartHistoryController.postData);
route.post('/cartHistory1',CartHistoryController.getData);
route.post('/favOrder',CartHistoryController.getFav);
route.post('/postFav',CartHistoryController.postFav);
route.post('/postSearch',PastSearchesConstroller.postPast);
route.post('/getSearch',PastSearchesConstroller.getPast);

module.exports=route;