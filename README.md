# Template Scripts

A collection of scripts for scaffolding projects

## Scripts

### express-be-template.ps1
Creates a new Express.js backend project from the template repository.

## Usage

```powershell
.\express-be-template.ps1 <project-name>
```

## Example

```powershell
.\express-be-template.ps1 my-new-api
```

## What the Script Does

- Clones the template repository
- Removes existing git history
- Initializes a new git repository with `main` as the default branch
- Installs all dependencies
- Updates package.json with the new project name and description
- Creates a .env file with default configuration
- Sets up Prisma client
- Optionally runs initial database migration
- Creates an initial commit with the message "feat: initialise project"

## Requirements

- Windows PowerShell 5.1 or higher
- Git installed and available in PATH
- Node.js and npm installed
- PostgreSQL database (for migrations)

## After Creation

Navigate to the project folder and update the .env file with your database credentials, then start the development server:

```powershell
cd <project-name>
npm run dev
```

## PowerShell Profile Helper Function

For easier access, add this function to your PowerShell profile:

1. Open your PowerShell profile:
```powershell
notepad $PROFILE
```

2. Add the following function:
```powershell
function New-ExpressTemplateProject {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectName
    )

    $scriptPath = "D:\path\to\your\scripts\express-be-template.ps1"
    & $scriptPath $ProjectName
}
```

3. Save the file and reload your profile:
```powershell
. $PROFILE
```

Now you can create new projects from anywhere:
```powershell
New-ExpressTemplateProject my-new-api
```

## Template Repository

The script uses the template from: https://github.com/ricky-ultimate/express-backend-starter-template
