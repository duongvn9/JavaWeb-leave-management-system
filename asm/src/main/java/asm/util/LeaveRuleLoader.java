package asm.util;
import org.yaml.snakeyaml.Yaml;
import java.io.InputStream;

public class LeaveRuleLoader {
    public static LeaveRuleConfig load() {
        Yaml yaml = new Yaml();
        try (InputStream in = LeaveRuleLoader.class.getClassLoader().getResourceAsStream("leave_rules.yml")) {
            return yaml.loadAs(in, LeaveRuleConfig.class);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
} 