const UserService=require('../services/user.services');

exports.register= async(req,res,next)=>{
    try{
        const {email,password,name,phone}=req.body;

        const success=await UserService.registerUser(email,password,name,phone);

        const user= await UserService.loginUser(email);
        let tokenData={_id:user._id,email:user.email,name:user.name,phone:user.phone};
        const token = await UserService.generateToken(tokenData,"123",'365d');

        res.status(200).json({status:true,token:token});
    }catch(e){
        throw e;
    }
}
exports.login= async(req,res,next)=>{
    try{
        const {email,password}=req.body;

        const user= await UserService.loginUser(email);

        if(!user){
            return res.status(200).json({ status: false });
        }

        const isMatch=await user.comparePassword(password);
        if(isMatch===false){
            return res.status(200).json({ status: false });
        }

        let tokenData={_id:user._id,email:user.email,name:user.name,phone:user.phone};

        const token = await UserService.generateToken(tokenData,"123",'365d');
        

        res.status(200).json({status:true,token:token});
    }catch(e){
        throw e;
    }
}