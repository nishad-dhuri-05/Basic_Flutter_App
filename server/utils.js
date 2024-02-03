import nodemailer from "nodemailer";

export const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "dep.test.p04@gmail.com",
    pass: "tfpfrvmxalvwlupl",
  },
});
