# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案概述

Nebuletta 是一個實驗性的基礎設施即代碼（IaC）專案，使用 Terraform 和 Terramate 在 AWS 上快速配置自管理的雲端基礎設施。

## 核心工具與版本

- **Terraform**: >= 1.11.4
- **Terramate**: >= 0.13.1  
- **AWS CLI**: >= 2.27.16
- **AWS Provider**: ~> 5.97
- **Random Provider**: ~> 3.1.0

## 專案架構

### 目錄結構
```
terraform/
├── modules/           # 可重複使用的 Terraform 模組
│   ├── networking/    # VPC、子網、路由表等網路資源
│   ├── compute/       # EC2 和 Fargate 運算資源
│   ├── s3/           # S3 儲存資源
│   └── state-storage/ # Terraform 狀態儲存
└── stacks/           # 不同環境的 Terramate 堆疊
    ├── dev/          # 開發環境
    └── random-id-generator/ # 通用隨機 ID 生成器
```

### Terramate 配置
- 全域配置位於 `terraform/terramate.tm.hcl`
- 環境特定配置位於 `terraform/stacks/dev/terramate.tm.hcl`
- 預設 AWS 區域：ap-northeast-1
- 狀態儲存使用 S3 + DynamoDB 鎖定機制

## 常用命令

### 基本 Terramate 操作
```bash
# 列出所有堆疊
terramate list

# 生成 Terraform 檔案
terramate generate

# 初始化專案
terramate init

# 規劃特定堆疊（以 networking 為例）
terramate run --tags networking -- terraform plan

# 應用特定堆疊
terramate run --tags networking -- terraform apply

# 銷毀特定堆疊
terramate run --tags networking -- terraform destroy
```

### 清理腳本
```bash
# 清理所有 Terraform 產生的檔案
./terraform_cleanup.sh
```

## 模組開發準則

### 命名規範
- 資源前綴：`${env}-${module_name}`
- 標籤結構：Environment, Project, ModuleName, Name, ManagedBy

### 模組結構
每個模組包含：
- `main.tf` - 提供者配置
- `locals.tf` - 本地變數和通用標籤
- `variables.tf` - 輸入變數
- `outputs.tf` - 輸出值
- `common.tfvars` - 通用變數值

### 堆疊結構
每個堆疊包含：
- `stack.tm.hcl` - Terramate 堆疊配置
- 自動生成的 `_terramate_generated_*.tf` 檔案

## 重要注意事項

1. **版本控制要求**：執行 `terramate init/plan/apply` 前必須確保沒有未提交的變更
2. **狀態管理**：使用 S3 + DynamoDB 進行遠端狀態管理
3. **標籤策略**：所有資源都使用統一的標籤架構進行管理
4. **區域設定**：預設為 ap-northeast-1，可透過全域變數調整

## 開發工作流程

1. 在 `terraform/modules/` 下開發可重複使用的模組
2. 在 `terraform/stacks/` 下建立環境特定的堆疊
3. 使用 `terramate generate` 生成必要的 Terraform 檔案
4. 使用標籤系統管理特定模組的部署
5. 使用清理腳本清理開發環境