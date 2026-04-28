#!/usr/bin/env pwsh
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

Write-Host "Creating new project: $ProjectName" -ForegroundColor Cyan

Write-Host "Cloning template..." -ForegroundColor Yellow
git clone https://github.com/ricky-ultimate/express-backend-starter-template.git $ProjectName

Set-Location $ProjectName

Write-Host "Removing template git history..." -ForegroundColor Yellow
Remove-Item -Recurse -Force .git

$parentGitPath = Get-Location | Split-Path -Parent | Join-Path -ChildPath ".git"
$hasParentGit = Test-Path $parentGitPath

if ($hasParentGit) {
    Write-Host "Detected parent git repository, skipping git init..." -ForegroundColor Yellow
} else {
    Write-Host "Initializing new git repository..." -ForegroundColor Yellow
    git init
    git branch -m master main
}

Write-Host "Installing dependencies..." -ForegroundColor Yellow
npm install

Write-Host "Updating package.json..." -ForegroundColor Yellow
$packageJson = Get-Content "package.json" | ConvertFrom-Json
$packageJson.name = $ProjectName
$packageJson.description = "New project created from template"
$packageJson | ConvertTo-Json -Depth 10 | Set-Content "package.json"

Write-Host "Creating .env file..." -ForegroundColor Yellow
if (Test-Path ".env.example") {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env from .env.example" -ForegroundColor Green
} else {
    @"
PORT=5001
DATABASE_URL="postgresql://postgres:password@localhost:5432/$ProjectName?schema=public"
"@ | Out-File -FilePath ".env" -Encoding UTF8
    Write-Host "Created default .env file - UPDATE THESE VALUES!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Database Setup" -ForegroundColor Cyan
$dbUrl = Read-Host "Enter your DATABASE_URL (press Enter to use default)"
if ($dbUrl) {
    (Get-Content ".env") -replace "DATABASE_URL=.*", "DATABASE_URL=`"$dbUrl`"" | Set-Content ".env"
}

Write-Host "Setting up Prisma..." -ForegroundColor Yellow
npx prisma generate

Write-Host ""
$runMigration = Read-Host "Do you want to run initial Prisma migration? (y/n)"
if ($runMigration -eq "y") {
    Write-Host "Creating initial migration..." -ForegroundColor Yellow
    npx prisma migrate dev --name init
    Write-Host "Migration completed!" -ForegroundColor Green
} else {
    Write-Host "Skipped migration. Run 'npx prisma migrate dev --name init' later" -ForegroundColor Yellow
}

Write-Host "Creating initial commit..." -ForegroundColor Yellow
git add .
git commit -m "feat: initialise project"

Write-Host ""
Write-Host "Template setup complete!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Project: $ProjectName" -ForegroundColor White
Write-Host "Location: $(Get-Location)" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. cd $ProjectName" -ForegroundColor White
Write-Host "  2. Update .env with your database credentials" -ForegroundColor White
Write-Host "  3. npm run dev" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan