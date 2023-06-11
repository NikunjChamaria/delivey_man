const mongoose=require('mongoose');

const connection=mongoose.createConnection('mongodb://127.0.0.1:27017/mr_delivery_man').on('open',()=>{
    console.log("MongoDb connected");
}).on('error',()=>{
    console.log("MongoDb connected error");
});

module.exports=connection;  