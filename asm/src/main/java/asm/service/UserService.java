package asm.service;

import asm.dao.UserDao;
import asm.model.User;

/**
 * Business layer cho user.
 */
public class UserService {
    private final UserDao userDao = new UserDao();

    /**
     * Tìm user theo google_id; nếu không thấy thì theo email; nếu vẫn không thấy → tạo mới.
     */
    public User findOrCreate(String googleId, String email, String fullName) {
        User u = null;
        if (googleId != null) {
            u = userDao.findByGoogleId(googleId);
        }
        if (u == null) {
            u = userDao.findByEmail(email);
        }
        if (u == null) {
            u = userDao.create(googleId, email, fullName);
        }
        return u;
    }
}
