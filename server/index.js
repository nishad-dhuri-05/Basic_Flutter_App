import express from "express";
import jwt from "jsonwebtoken";
import cors from "cors";
import mongoose from "mongoose";
import cookieParser from "cookie-parser";

import OTP from "./models/otpModel.js";
import User from "./models/userModel.js";

const app = express();
const port = 5000;
const secretKey = "qwertyStyle";

app.use(cors());
app.use(express.json());
app.use(cookieParser());

app.get("/", (req, res) => {
  res.json({
    message: "A simple API",
  });
});

app.post("/otp", async (req, res) => {
  console.log("\n\n\nOtp has been requested\n\n\n");
  console.log(req.body)
  const { email } = req.body;
  const result=await User.findOne({email:email});
  // if(result==null){
  //   return res.status(400).json({userExists:false,message:"User not found"});
  // }
  const generateOtp = () => {
    let otp = "";
    for (let i = 0; i < 6; i++) {
      otp += Math.floor(Math.random() * 10);
    }
    return otp;
  };
  try {
    const otp = generateOtp();

    await OTP.deleteMany({ email: req.body.email });

    const otpBody = await OTP.create({ email: req.body.email, otp });
    res.status(200).json({
      userExists:true,
      message: "OTP sent successfully",
    });
    console.log(otpBody);
  } catch (err) {
    console.log(err.message);
    res.status(500).json({ error: err.message });
  }
});

app.post("/register", async (req, res) => {
  //const user = req.body.user;
  //console.log(user);
  //const email = user.email;
  const email=req.body.email;
  const name=req.body.name;
  const contact=req.body.contact;
  const address=req.body.address;
  const result = await User.findOne({ email: email });
  const result2=await User.findOne({contact:contact});
  if (!result && !result2) {
    const newUser = await User.create({email,name,contact,address});
    const refreshToken = jwt.sign({ email }, "Secret key for refresh token", {
      expiresIn: "180d",
    });
    const accessToken = jwt.sign({ email }, "Secret key for access token", {
      expiresIn: "5m",
    });

    console.log("User saved");
    return res
      .status(200)
      .cookie("accessToken", accessToken, { httpOnly: true })
      .cookie("refreshToken", refreshToken, { httpOnly: true })
      .json({
        success: true,
        accessToken,
        refreshToken,
        message: "User added successfully",
      });
  } else {
    return res
      .status(400)
      .json({ success: false, message: "Phone number/email already in use" });
  }
});

app.post("/login", async (req, res) => {
  // const user = {
  //     id: 1,
  //     username: "vipul",
  //     email: "abc@gmail.com"
  // };
  // jwt.sign({ user }, secretKey, {expiresIn: "1h"}, (err, token) => {
  //     res.json({
  //         token
  //     })
  // })
  // console.log(req.body);
  // console.log(res);
  // console.log(req.body?.credentials?.email);

  //const { email, otp } = req?.body?.credentials;
  const {email,otp}=req.body;
  const result = await OTP.findOne({ email, otp });

  if (result) {
    const user = await User.findOne({ email: email });
    console.log("User logged in successfully");
    if (user) {
      const refreshToken = jwt.sign({ email }, "Secret key for refresh token", {
        expiresIn: "180d",
      });
      const accessToken = jwt.sign({ email }, "Secret key for access token", {
        expiresIn: "5m",
      });

      // if(user) axios.post('/login',{email:user.email});
      res
        .status(200)
        .cookie("accessToken", accessToken, { httpOnly: true })
        .cookie("refreshToken", refreshToken, { httpOnly: true })
        .json({
          success: true,
          user: user,
          message: "User logged in successfully",
          accessToken,
          refreshToken,
        });
    } else {
      res.status(400).json({
        success: false,
        message: "User does not exist",
      });
    }
  } else {
    console.log("OTP entered is wrong");
    res.status(500).json({ success: false, message: "OTP entered is wrong" });
  }
});

app.get("/logout", (req, res) => {
  res.cookie("accessToken", "", { httpOnly: true, maxAge: -1000 });
  res.cookie("refreshToken", "", { httpOnly: true, maxAge: -1000 });

  res.status(200).json({ message: "Logged out successfully" });
});



app.post("/profile", verifyToken, async (req, res) => {
  console.log(req.body.accessToken)
  jwt.verify(req.body.accessToken, "Secret key for access token",async (err, authData) => {
    if (err) {
      return res.send({
        result: "Invalid Token",
      });
    } else {
      const email=authData.email;
      console.log(email)
      const user= await User.findOne({email:email});
      //console.log(user)
      console.log(user.email)
      console.log(user.name)
      console.log(user.contact)
      console.log(user.address)
      return res.json({
        email:user.email,
        name:user.name,
        contact:user.contact,
        address:user.address
      });
    }
  });
});

function getToken(refreshToken) {
  if (refreshToken == null) return null;
  jwt.verify(refreshToken, "Secret key for refresh token", (err, data) => {
    // console.log("user:",user);
    if (err) return null;
    const email = data.email;
    const accessToken = jwt.sign({ email }, "Secret key for access token");
    // console.log({ accessToken: accessToken, user: user });
    // console.log(user);
    var data = { accessToken: accessToken, email: email };
    console.log(data);
    return data;
  });
}

app.get("/token", (req, res) => {
  const refreshToken = req.cookies.refreshToken;
  console.log(refreshToken);
  if (refreshToken == null)
    return res.status(400).json({ message: "Refresh token is not present" });

  jwt.verify(refreshToken, "Secret key for refresh token", (err, data) => {
    // console.log("user:",user);
    if (!err) {
      const { email } = data;
      const accessToken = jwt.sign({ email }, "Secret key for access token");
      console.log(data);
      return res.status(200).json({ accessToken });
    } else {
      return res.status(400).json({ message: "Invalid refresh token" });
    }
  });
});


app.put("/user/:email",verifyToken,async (req,res)=>{
  console.log("Profile update request received")
  const email=req.params.email;
  console.log(email);
  const name=req.body.name;
  //const contact=req.body.contact;
  const address=req.body.address;
  console.log(name);
  //console.log(contact);
  console.log(address);
  const user=await User.findOneAndUpdate({email:email},{name:name,address:address},{new:true});
  console.log(user);
  return res.status(200).json({success:true,message:"User updated successfully"})
})
// function verifyToken(req, res, next) {
//   const accessToken = req.body.accessToken;
//   const refreshToken = req.body.refreshToken;
//   //console.log(accessToken)
//   jwt.verify(accessToken, "Secret key for access token", (err, user) => {
//     // if (err) return res.status(403).json({ message: "Invalid token" });
//     if (!err) {
//       //req.user = user;
//       console.log(user);
//       next();
//     }
//   });

//   const data = getToken(refreshToken);

//   if (data) {
//     const { accessToken, user } = data;
//     req.cookies.accessToken = accessToken;
//     //req.user = user;
//     next();
//   }
//   return res.status(403).json({ message: "You are not authorized" });
// }

function verifyToken(req, res, next) {
  const accessToken = req.body.accessToken;
  const refreshToken = req.body.refreshToken;

  jwt.verify(accessToken, "Secret key for access token", (err, user) => {
    if (!err) {
      //req.user = user;
      //console.log(user);
      next();
    } else {
      const data = getToken(refreshToken);

      if (data) {
        //const { accessToken, user } = data;
        //req.cookies.accessToken = accessToken;
        //req.user = user;
         return next();
      } else {
        return res.status(403).json({ message: "You are not authorized" });
      }
    }
  });
}

mongoose
  .connect(
    "mongodb+srv://deptestp04:hardikaggarwal@cluster0.vcrdcme.mongodb.net/?retryWrites=true&w=majority"
  )
  .then(() => {
    console.log("Connected to database");
    app.listen(port, () => {
      console.log(`Server is runnning at port ${port}`);
    });
  })
  .catch((err) => console.log(err));

