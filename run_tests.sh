#!/bin/bash
# ============================================================
#  Soul Injector - 一键测试脚本
# ============================================================
#  Author: Fangooer Team
#  Contact: fangooer@163.com
#  Version: 1.0.0
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# 统计变量
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 测试根目录
TEST_ROOT="$HOME/soul-injector-tests"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="$TEST_ROOT/test-report-$(date +%Y%m%d-%H%M%S).txt"

# 打印函数
print_banner() {
    echo ""
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║           Soul Injector - 一键测试套件 v1.0.0              ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_pass() {
    ((PASSED_TESTS++))
    echo -e "${GREEN}✅ PASS${NC}"
}

print_fail() {
    ((FAILED_TESTS++))
    echo -e "${RED}❌ FAIL${NC}"
}

# 测试函数
run_test() {
    local test_name="$1"
    ((TOTAL_TESTS++))
    printf "  [%02d] %-50s" $TOTAL_TESTS "$test_name"
}

# 报告标题
echo_report() {
    echo "$1" | tee -a "$REPORT_FILE"
}

print_banner

# 创建测试目录
echo -e "${BLUE}📁 准备测试环境...${NC}"
rm -rf "$TEST_ROOT"
mkdir -p "$TEST_ROOT"

# 创建报告文件
echo "Soul Injector Test Report" > "$REPORT_FILE"
echo "=========================" >> "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo -e "  测试根目录: $TEST_ROOT"
echo -e "  测试报告: $REPORT_FILE"
echo ""

# ============================================================
# 第一阶段：文件完整性验证测试
# ============================================================
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  第一阶段：文件完整性验证测试${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo_report "Phase 1: File Integrity Tests"
echo_report "--------------------------------"

# 测试 1.1：检查根目录文件
run_test "根目录 LICENSE 文件存在"
if [ -f "$SCRIPT_DIR/LICENSE" ]; then print_pass; echo_report "  ✅ LICENSE exists"; else print_fail; echo_report "  ❌ LICENSE missing"; fi

run_test "根目录 README.md 文件存在"
if [ -f "$SCRIPT_DIR/README.md" ]; then print_pass; echo_report "  ✅ README.md exists"; else print_fail; echo_report "  ❌ README.md missing"; fi

run_test "根目录 SKILL.md 文件存在"
if [ -f "$SCRIPT_DIR/SKILL.md" ]; then print_pass; echo_report "  ✅ SKILL.md exists"; else print_fail; echo_report "  ❌ SKILL.md missing"; fi

run_test "根目录 _meta.json 文件存在"
if [ -f "$SCRIPT_DIR/_meta.json" ]; then print_pass; echo_report "  ✅ _meta.json exists"; else print_fail; echo_report "  ❌ _meta.json missing"; fi

# 测试 1.2：检查 scripts 目录
run_test "scripts 目录存在"
if [ -d "$SCRIPT_DIR/scripts" ]; then print_pass; echo_report "  ✅ scripts directory exists"; else print_fail; echo_report "  ❌ scripts directory missing"; fi

run_test "install.sh 脚本存在"
if [ -f "$SCRIPT_DIR/scripts/install.sh" ]; then print_pass; echo_report "  ✅ install.sh exists"; else print_fail; echo_report "  ❌ install.sh missing"; fi

run_test "assess.sh 脚本存在"
if [ -f "$SCRIPT_DIR/scripts/assess.sh" ]; then print_pass; echo_report "  ✅ assess.sh exists"; else print_fail; echo_report "  ❌ assess.sh missing"; fi

run_test "soul-config.sh 脚本存在"
if [ -f "$SCRIPT_DIR/scripts/soul-config.sh" ]; then print_pass; echo_report "  ✅ soul-config.sh exists"; else print_fail; echo_report "  ❌ soul-config.sh missing"; fi

# 测试 1.3：检查 templates 目录
run_test "templates 目录存在"
if [ -d "$SCRIPT_DIR/templates" ]; then print_pass; echo_report "  ✅ templates directory exists"; else print_fail; echo_report "  ❌ templates directory missing"; fi

TEMPLATE_FILES=("SOUL.md" "AGENTS.md" "USER.md" "MEMORY.md" "SESSION-STATE.md" "HEARTBEAT.md" "TOOLS.md" "SKILL_REGISTRY.md")
for file in "${TEMPLATE_FILES[@]}"; do
    run_test "模板文件 $file 存在"
    if [ -f "$SCRIPT_DIR/templates/$file" ]; then print_pass; echo_report "  ✅ templates/$file exists"; else print_fail; echo_report "  ❌ templates/$file missing"; fi
done

run_test "templates/memory 子目录存在"
if [ -d "$SCRIPT_DIR/templates/memory" ]; then print_pass; echo_report "  ✅ templates/memory exists"; else print_fail; echo_report "  ❌ templates/memory missing"; fi

run_test "working-buffer.md 模板存在"
if [ -f "$SCRIPT_DIR/templates/memory/working-buffer.md" ]; then print_pass; echo_report "  ✅ templates/memory/working-buffer.md exists"; else print_fail; echo_report "  ❌ templates/memory/working-buffer.md missing"; fi

echo ""

# ============================================================
# 第二阶段：脚本可执行性测试
# ============================================================
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  第二阶段：脚本可执行性测试${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo_report ""
echo_report "Phase 2: Script Executability Tests"
echo_report "--------------------------------"

chmod +x "$SCRIPT_DIR"/scripts/*.sh

for script in install.sh assess.sh soul-config.sh; do
    run_test "$script 有执行权限"
    if [ -x "$SCRIPT_DIR/scripts/$script" ]; then print_pass; echo_report "  ✅ $script is executable"; else print_fail; echo_report "  ❌ $script is not executable"; fi
done

run_test "_meta.json 是合法 JSON 格式"
if python3 -c "import json; json.load(open('$SCRIPT_DIR/_meta.json'))" 2>/dev/null || jq . "$SCRIPT_DIR/_meta.json" >/dev/null 2>&1; then
    print_pass
    echo_report "  ✅ _meta.json is valid JSON"
else
    print_fail
    echo_report "  ❌ _meta.json is NOT valid JSON"
fi

echo ""

# ============================================================
# 第三阶段：新生儿模式部署测试
# ============================================================
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  第三阶段：新生儿模式部署测试${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo_report ""
echo_report "Phase 3: Newborn Mode Deployment Tests"
echo_report "------------------------------------"

NEWBORN_DIR="$TEST_ROOT/newborn-agent"
run_test "执行新生儿模式部署"
if bash "$SCRIPT_DIR/scripts/install.sh" -n "$NEWBORN_DIR" >"$TEST_ROOT/install.log" 2>&1; then
    print_pass
    echo_report "  ✅ Newborn mode deployment succeeded"
else
    print_fail
    echo_report "  ❌ Newborn mode deployment failed. Log: $TEST_ROOT/install.log"
fi

# 验证部署结果
for file in SOUL.md AGENTS.md USER.md MEMORY.md SESSION-STATE.md HEARTBEAT.md TOOLS.md SKILL_REGISTRY.md; do
    run_test "部署后 $file 存在"
    if [ -f "$NEWBORN_DIR/$file" ]; then print_pass; echo_report "  ✅ $file deployed"; else print_fail; echo_report "  ❌ $file NOT deployed"; fi
done

run_test "部署后 memory 目录存在"
if [ -d "$NEWBORN_DIR/memory" ]; then print_pass; echo_report "  ✅ memory directory deployed"; else print_fail; echo_report "  ❌ memory directory NOT deployed"; fi

run_test "部署后 working-buffer.md 存在"
if [ -f "$NEWBORN_DIR/memory/working-buffer.md" ]; then print_pass; echo_report "  ✅ memory/working-buffer.md deployed"; else print_fail; echo_report "  ❌ memory/working-buffer.md NOT deployed"; fi

echo ""

# ============================================================
# 第四阶段：升级评估引擎测试
# ============================================================
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  第四阶段：升级评估引擎测试${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo_report ""
echo_report "Phase 4: Assessment Engine Tests"
echo_report "--------------------------------"

run_test "对完整架构 Agent 评估测试"
if bash "$SCRIPT_DIR/scripts/assess.sh" "$NEWBORN_DIR" >"$TEST_ROOT/assess-full.log" 2>&1; then
    print_pass
    echo_report "  ✅ Full agent assessment succeeded"
else
    print_fail
    echo_report "  ❌ Full agent assessment failed. Log: $TEST_ROOT/assess-full.log"
fi

run_test "评估输出包含 '灵魂定位' 关键字"
if grep -q "灵魂定位" "$TEST_ROOT/assess-full.log" || grep -q "SOUL" "$TEST_ROOT/assess-full.log"; then
    print_pass
    echo_report "  ✅ Assessment contains '灵魂定位/SOUL' check"
else
    print_fail
    echo_report "  ❌ Assessment does NOT contain '灵魂定位/SOUL' check"
fi

run_test "评估输出包含 '评分' 或 'score' 关键字"
if grep -qi "评分\|score\|得分" "$TEST_ROOT/assess-full.log"; then
    print_pass
    echo_report "  ✅ Assessment contains score output"
else
    print_fail
    echo_report "  ❌ Assessment does NOT contain score output"
fi

# 空目录评估测试
EMPTY_DIR="$TEST_ROOT/empty-agent"
mkdir -p "$EMPTY_DIR"

run_test "对空目录评估测试"
if bash "$SCRIPT_DIR/scripts/assess.sh" "$EMPTY_DIR" >"$TEST_ROOT/assess-empty.log" 2>&1; then
    print_pass
    echo_report "  ✅ Empty directory assessment succeeded"
else
    print_fail
    echo_report "  ❌ Empty directory assessment failed"
fi

echo ""

# ============================================================
# 第五阶段：内容验证测试
# ============================================================
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  第五阶段：内容验证测试${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo_report ""
echo_report "Phase 5: Content Validation Tests"
echo_report "---------------------------------"

run_test "SOUL.md 包含 'Fangooer Team' 版权声明"
if grep -q "Fangooer Team" "$SCRIPT_DIR/templates/SOUL.md"; then
    print_pass
    echo_report "  ✅ SOUL.md has Fangooer Team copyright"
else
    print_fail
    echo_report "  ❌ SOUL.md missing Fangooer Team copyright"
fi

run_test "_meta.json 包含 'soul-injector' slug"
if grep -q "soul-injector" "$SCRIPT_DIR/_meta.json"; then
    print_pass
    echo_report "  ✅ _meta.json has correct slug"
else
    print_fail
    echo_report "  ❌ _meta.json missing correct slug"
fi

run_test "LICENSE 文件包含 MIT 协议"
if grep -qi "MIT License" "$SCRIPT_DIR/LICENSE"; then
    print_pass
    echo_report "  ✅ LICENSE has MIT agreement"
else
    print_fail
    echo_report "  ❌ LICENSE missing MIT agreement"
fi

run_test "LICENSE 文件包含版权声明"
if grep -q "2026 Fangooer Team" "$SCRIPT_DIR/LICENSE"; then
    print_pass
    echo_report "  ✅ LICENSE has Fangooer Team copyright"
else
    print_fail
    echo_report "  ❌ LICENSE missing copyright"
fi

run_test "assess.sh 脚本头部有版权声明"
if grep -q "Fangooer Team" "$SCRIPT_DIR/scripts/assess.sh"; then
    print_pass
    echo_report "  ✅ assess.sh has copyright header"
else
    print_fail
    echo_report "  ❌ assess.sh missing copyright header"
fi

echo ""

# ============================================================
# 测试总结
# ============================================================
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}  📊 测试总结${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo_report ""
echo_report "Test Summary"
echo_report "------------"
echo_report "Total Tests: $TOTAL_TESTS"
echo_report "Passed:      $PASSED_TESTS"
echo_report "Failed:      $FAILED_TESTS"

SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
echo_report "Success Rate: $SUCCESS_RATE%"

echo ""
echo -e "  📊 总测试数: ${CYAN}$TOTAL_TESTS${NC}"
echo -e "  ✅ 通过:     ${GREEN}$PASSED_TESTS${NC}"
echo -e "  ❌ 失败:     ${RED}$FAILED_TESTS${NC}"
echo -e "  📈 成功率:   ${YELLOW}$SUCCESS_RATE%${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}  🎉 所有测试全部通过！完美！${NC}"
    echo_report ""
    echo_report "Result: ALL TESTS PASSED! 🎉"
else
    echo -e "${YELLOW}  ⚠️  有 $FAILED_TESTS 个测试失败，请检查日志${NC}"
    echo_report ""
    echo_report "Result: SOME TESTS FAILED"
    echo_report "Check logs in: $TEST_ROOT"
fi

echo ""
echo -e "📝 完整测试报告已保存到: ${BLUE}$REPORT_FILE${NC}"
echo -e "📁 所有测试日志在: ${BLUE}$TEST_ROOT/${NC}"
echo ""
echo -e "${CYAN}请把测试报告内容反馈给小山团队，谢谢！${NC}"
echo ""
