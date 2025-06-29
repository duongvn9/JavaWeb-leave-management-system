package asm.service;

import asm.integrations.GeminiClient;
import asm.model.LeaveRequest;
import asm.util.AppConfig;
import asm.util.LeaveRuleConfig;
import asm.util.LeaveRuleLoader;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

public class LeaveAutoService {
    private final GeminiClient geminiClient;

    // Load rule từ YAML, chỉ load 1 lần khi class được load
    private static final LeaveRuleConfig RULE = LeaveRuleLoader.load();
    private static final int MAX_DAYS = RULE != null ? RULE.getMax_days() : 3;
    private static final java.util.Set<String> SPECIAL_SET = RULE != null ? new HashSet<>(RULE.getSpecial_reasons()) : new HashSet<>();

    /**
     * Danh sách lý do đặc biệt (không dấu, lower-case).
     */
    public static final String[] SPECIAL_CASES = {
        // 1. Ốm đau – y tế
        "om nang", "nhap vien", "tai nan", "tai nan giao thong",
        "kham benh", "kham suc khoe", "kham thai",
        "phau thuat", "giai phau", "dieu tri",
        // 2. Maternity / Paternity / Adoption
        "nghi thai san", "sinh con", "vo sinh", "vo de",
        "chong sinh", "chong de", "nhan con nuoi", "adopt",
        // 3. Hiếu – tang
        "dam tang", "dam ma", "gia dinh co tang", "le tang",
        "bo mat", "me mat", "ong mat", "ba mat",
        // 4. Hỷ
        "ket hon", "dam cuoi", "dam hoi", "le dinh hon",
        // 5. Chăm sóc/thân nhân
        "cham soc con om", "con om", "bo me om",
        "vo om", "chong om", "nguoi than bi benh nan y",
        // 6. Thi cử – giáo dục
        "thi tot nghiep", "thi lai xe", "thi bang lai",
        "bao ve luan van", "thi cao hoc",
        // 7. Nghĩa vụ & Pháp lý
        "nghia vu quan su", "giao nghia vu", "hau toa", "hau toan",
        "hau toa an", "lam chung toa an", "lam giay to phap ly",
        // 8. Sự cố khẩn cấp
        "chay nha", "ngap nha", "vo ong nuoc", "mat dien keo dai",
        "sap nha", "sap tran", "dot bien",
        // 9. Hoạt động xã hội
        "hien mau", "tu thien", "ngay hoi hien mau", "tinh nguyen",
        ""
    };

    public LeaveAutoService() {
        this.geminiClient = new GeminiClient(AppConfig.geminiEndpoint(), AppConfig.geminiApiKey());
    }

    public String autoApprove(String prompt) {
        // Đóng gói prompt thành JSON theo API Gemini
        String promptJson = String.format("{\"contents\":[{\"parts\":[{\"text\":\"%s\"}]}]}", prompt.replace("\"", "\\\""));
        try {
            return geminiClient.decide(promptJson).getDecision();
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // Hàm evaluate nhận LeaveRequest, tạo prompt và gọi AI
    public String evaluate(LeaveRequest lr, int annualLeaveRemaining) {
        long days = ChronoUnit.DAYS.between(lr.getFromDate(), lr.getToDate()) + 1;
        String reasonRaw = lr.getReason() == null ? "" : lr.getReason();
        String reasonNorm = stripAccents(reasonRaw).toLowerCase();
        boolean isSpecial = SPECIAL_SET.stream().anyMatch(reasonNorm::contains);

        // Rule cứng ở backend: dùng max_days từ YAML
        if (days > MAX_DAYS && !isSpecial) return "REJECTED";

        // Rule mềm – nhờ Gemini đánh giá
        String specialKeywords = String.join(", ", RULE != null ? RULE.getSpecial_reasons() : java.util.Collections.emptyList());
        String prompt = String.format(
            "Theo chính sách công ty:\n" +
            "• Không duyệt lý do \"đi chơi\".\n" +
            "• Tự động từ chối nếu ngày phép còn lại < số ngày xin.\n" +
            "• Tự động từ chối nếu xin > %d ngày TRỪ KHI lý do nằm trong nhóm đặc biệt: %s.\n" +
            "\n" +
            "Nhân viên %s xin nghỉ %d ngày (từ %s đến %s) với lý do: \"%s\" (phép còn lại: %d ngày).\n" +
            "Trả lời duy nhất một từ: yes / no / consider.\n",
            MAX_DAYS,
            specialKeywords,
            lr.getEmployeeName(),
            days,
            lr.getFromDate(),
            lr.getToDate(),
            reasonRaw,
            annualLeaveRemaining
        );
        return autoApprove(prompt);
    }

    // Hàm loại bỏ dấu tiếng Việt (nếu chưa có commons-lang3)
    public static String stripAccents(String s) {
        if (s == null) return null;
        String temp = java.text.Normalizer.normalize(s, java.text.Normalizer.Form.NFD);
        return temp.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
    }
} 