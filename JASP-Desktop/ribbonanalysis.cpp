#include "ribbonanalysis.h"
#include "ui_ribbonanalysis.h"

#include <QMenu>
#include <QDebug>

RibbonAnalysis::RibbonAnalysis(QWidget *parent) :
	QWidget(parent),
	ui(new Ui::RibbonAnalysis)
{
	ui->setupUi(this);

	QMenu *menu = new QMenu(this);

	menu->addAction(QString("Independent Samples T-Test"), this, SLOT(itemSelected()))->setObjectName("TTestIndependentSamples");
	menu->addAction(QString("Paired Samples T-Test"), this, SLOT(itemSelected()))->setObjectName("TTestPairedSamples");
	menu->addAction(QString("One Sample T-Test"), this, SLOT(itemSelected()))->setObjectName("TTestOneSample");

	ui->classicalTTestButton->setMenu(menu);

	menu = new QMenu(this);
	menu->addAction(QString("One Way ANOVA"), this, SLOT(itemSelected()))->setObjectName("AnovaOneWay");
	menu->addAction(QString("ANOVA"), this, SLOT(itemSelected()))->setObjectName("Anova");
	menu->addAction(QString("ANCOVA"), this, SLOT(itemSelected()))->setObjectName("Ancova");
	menu->addAction(QString("MAN(C)OVA"), this, SLOT(itemSelected()))->setObjectName("AncovaMultivariate");
	//menu->addAction(QString("MANCOVA"), this, SLOT(itemSelected()))->setObjectName("AncovaMultivariate");

	ui->classicalAnovaButton->setMenu(menu);

	menu = new QMenu(this);
	menu->addAction(QString("Correlation"), this, SLOT(itemSelected()))->setObjectName("Correlation");
	menu->addAction(QString("Linear Regression"), this, SLOT(itemSelected()))->setObjectName("RegressionLinear");
	menu->addSeparator();
	menu->addAction(QString("Contingency Tables"), this, SLOT(itemSelected()))->setObjectName("ContingencyTables");

	ui->classicalRegressionButton->setMenu(menu);

	connect(ui->Crosstabs, SIGNAL(clicked()), this, SLOT(itemSelected()));

	menu = new QMenu(this);
	menu->addAction(QString("Bayesian One Sample T-Test"), this, SLOT(itemSelected()))->setObjectName("TTestBayesianOneSample");

	ui->bayesianTTestButton->setMenu(menu);

	menu = new QMenu(this);
	menu->addAction(QString("Bayesian ANOVA"), this, SLOT(itemSelected()))->setObjectName("AnovaBayesian");

	ui->bayesianAnovaButton->setMenu(menu);
}

RibbonAnalysis::~RibbonAnalysis()
{
	delete ui;
}

void RibbonAnalysis::itemSelected()
{
	QObject *source = this->sender();
	QString name = source->objectName();

	emit itemSelected(name);
}

void RibbonAnalysis::menuItemSelected()
{
	QPushButton *source = dynamic_cast<QPushButton*>(this->sender());
	if (source != NULL)
		source->showMenu();
}
