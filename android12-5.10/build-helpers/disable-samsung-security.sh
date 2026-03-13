#!/bin/bash
# Disable Samsung security subsystems (UH/RKP/KDP/DEFEX/PROCA/FIVE) in defconfig
# Without this, KSU module loading is blocked at boot

DEFCONFIG="$1"
[ -f "$DEFCONFIG" ] || { echo "disable-samsung-security: defconfig not found: $DEFCONFIG"; exit 1; }

CONFIGS=(
  CONFIG_UH
  CONFIG_UH_RKP
  CONFIG_UH_LKMAUTH
  CONFIG_UH_LKM_BLOCK
  CONFIG_RKP_CFP_JOPP
  CONFIG_RKP_CFP
  CONFIG_SECURITY_DEFEX
  CONFIG_PROCA
  CONFIG_FIVE
  CONFIG_RKP
)

for cfg in "${CONFIGS[@]}"; do
  sed -i "s/^${cfg}=y/# ${cfg} is not set/" "$DEFCONFIG"
  sed -i "s/^${cfg}=m/# ${cfg} is not set/" "$DEFCONFIG"
  grep -q "^# ${cfg} is not set" "$DEFCONFIG" || echo "# ${cfg} is not set" >> "$DEFCONFIG"
done

echo "disable-samsung-security: disabled ${#CONFIGS[@]} security configs in $(basename "$DEFCONFIG")"
