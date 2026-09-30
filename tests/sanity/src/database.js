import { createRequire } from 'node:module';
import { join } from 'node:path';

let mongoose;
let User;
let OTP;

export async function connectDatabase() {
  const backendDirectory = process.env.SANITY_BACKEND_DIR;
  const uri = process.env.SANITY_DATABASE_URI || 'mongodb://127.0.0.1:27017/vocle_sanity';
  if (!backendDirectory) throw new Error('SANITY_BACKEND_DIR is required for independent database checks.');
  const backendRequire = createRequire(join(backendDirectory, 'package.json'));
  mongoose = backendRequire('mongoose');
  User = backendRequire(join(backendDirectory, 'src/features/users/user.model.js'));
  OTP = backendRequire(join(backendDirectory, 'src/features/auth/otp.model.js'));
  await mongoose.connect(uri, { serverSelectionTimeoutMS: 10_000 });
}

export async function closeDatabase() {
  await mongoose?.disconnect();
}

export async function userByPhone(phone) {
  return User.findOne({ phone }).lean();
}

export async function newestOtp(phone) {
  return OTP.findOne({ phone }).sort({ createdAt: -1 }).lean();
}
