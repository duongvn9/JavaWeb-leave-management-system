package asm.util;
import java.util.List;

public class LeaveRuleConfig {
    private int max_days;
    private List<String> special_reasons;
    private boolean auto_approve_enabled;

    public int getMax_days() { return max_days; }
    public void setMax_days(int max_days) { this.max_days = max_days; }

    public List<String> getSpecial_reasons() { return special_reasons; }
    public void setSpecial_reasons(List<String> special_reasons) { this.special_reasons = special_reasons; }

    public boolean isAuto_approve_enabled() { return auto_approve_enabled; }
    public void setAuto_approve_enabled(boolean auto_approve_enabled) { this.auto_approve_enabled = auto_approve_enabled; }
} 