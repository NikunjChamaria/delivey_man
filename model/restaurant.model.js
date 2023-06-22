const db=require('../config/db');
const mongoose=require('mongoose');
const e = require('express');

const { Schema }=mongoose;

const restaurantSchema=new Schema({
    resName:{
        type:String,
        
    },
   
    rating:{
        type:Number,
        required:false,
    },
    dist:{
        type:Number,
        required:false,
    },
    comments:Number,
    averagePrice:Number,
    foodType:Array,
    location:String,
    ownerEmail:String,
    businessEmail:String,
    address:String,
    lat:Number,
    long:Number
});



const RestaurantModel=db.model('restaurant',restaurantSchema);

module.exports=RestaurantModel;