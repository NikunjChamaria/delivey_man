const route=require('express').Router();
const UserController=require("../controller/user.controller");
const PopularFoodMianController=require("../controller/popularfoodmainpage.controller");
const PopularProductMianController=require("../controller/popularprodutmain.controller");
const RestaurantController=require("../controller/restaurantcontroller");
const FoodController=require("../controller/food.controller");
const CategoryController=require("../controller/category.controller");
const CartHistoryController=require('../controller/cartHistory.controller');
const PastSearchesConstroller=require('../controller/pastsearches.controller');
const ImageController=require('../controller/image.controller');
const FoodImageController=require('../controller/foodimage.cpntroller');
const ImageModel = require('../model/image.model');
const FoodImageModel=require('../model/foodimage.model');
const multer = require('multer');

const storage=multer.diskStorage({
    destination:'uploads',
    filename:(req,file,cb)=>{
        cb(null,Date.now+file.originalname)
    }
});

const storage1=multer.diskStorage({
  destination:'uploadsFood',
  filename:(req,file,cb)=>{
      cb(null,Date.now+file.originalname)
  }
});
const upload = multer({ storage });
const upload1 = multer({ storage1 });
const fs = require('fs');




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
route.post('/restaurant3',RestaurantController.getData3);
route.post('/searchRes',RestaurantController.search);
route.post('/food',FoodController.postData);
route.post('/food1',FoodController.getData);
route.post('/food2',FoodController.getData1);
route.post('/searchFood',FoodController.search);
route.post('/category',CategoryController.postData);
route.get('/category',CategoryController.getData);
route.post('/cartHistory',CartHistoryController.postData);
route.post('/cartHistory1',CartHistoryController.getData);
route.post('/favOrder',CartHistoryController.getFav);
route.post('/postFav',CartHistoryController.postFav);
route.post('/preparing',CartHistoryController.getPreparing);
route.post('/delivered',CartHistoryController.postDelivered);
route.post('/postSearch',PastSearchesConstroller.postPast);
route.post('/getSearch',PastSearchesConstroller.getPast);
route.post('/downloadImage',ImageController.download);
route.post('/downloadFoodImage',FoodImageController.download);






route.post('/uploadImage', upload.single('image'), (req, res) => {
    if (!req.file) {
      return res.status(400).send('No image provided');
    }
  
    const imagePath = req.file.path;

    fs.readFile(imagePath, (error, data) => {
      if (error) {
        console.error(error);
        return res.status(500).send('Internal server error');
      }
  
      const image = {
        data: data,
        contentType: req.file.mimetype,
      };
      const ownerEmail = req.body.ownerEmail;
      const resName = req.body.resName;
  
    try {
        const newImage= new ImageModel({image,ownerEmail,resName});
        newImage.save();
    res.send({"text":"yo"});
    } catch (error) {
        throw error;
    }});
  });

  route.post('/uploadFoodImage', upload.single('imagefood'), (req, res) => {
    if (!req.file) {
      return res.status(400).send('No image provided');
    }
  
    const imagePath = req.file.path;
    

    fs.readFile(imagePath, (error, data) => {
      if (error) {
        console.error(error);
        return res.status(500).send('Internal server error');
      }
  
      const image = {
        data: data,
        contentType: req.file.mimetype,
      };
      const ownerEmail = req.body.ownerEmail;
      const resName = req.body.resName;
      const foodName=req.body.foodName;
  
    try {
        const newImage= new FoodImageModel({image,ownerEmail,resName,foodName});
        newImage.save();
    res.send({"text":"yo"});
    } catch (error) {
        throw error;
    }});
  });

module.exports=route;