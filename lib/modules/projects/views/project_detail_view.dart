import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/project_model.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/project_controller.dart';
import 'widgets/summary_card.dart';
import 'widgets/recent_sessions_list.dart';
import 'widgets/weekly_comparison_card.dart';
import 'widgets/milestone_card.dart';
import 'widgets/kanban_board_view.dart';
import 'widgets/analytics_tab_view.dart';

import 'widgets/project_form_dialog.dart';

class ProjectDetailView extends StatefulWidget {
  final ProjectModel project;
  const ProjectDetailView({super.key, required this.project});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildTopHeader(widget.project)),
          _buildTabContent(widget.project),
        ],
      ),
    );
  }

  Widget _buildTopHeader(ProjectModel project) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.darkDivider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          Get.find<ProjectController>().selectProject(null),
                      child: const Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.darkTextMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                              color: AppColors.darkTextPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (project.clientName.isNotEmpty)
                            Text(
                              'Client: ${project.clientName}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.darkTextSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              Get.dialog(ProjectFormDialog(project: project)),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit Project'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkTextPrimary,
                            side: const BorderSide(
                              color: AppColors.darkBorder,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow_rounded, size: 20),
                          label: const Text('Start Timer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTabBar(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(ProjectModel project) {
    final currencyFormat = NumberFormat.simpleCurrency(name: project.currency);

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 0),
      child: Row(
        children: [
          Expanded(
            child: SummaryCard(
              title: 'Hourly Rate',
              value: currencyFormat.format(project.hourlyRate),
              subtitle: 'Fixed rate per hour',
              icon: Icons.payments_outlined,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SummaryCard(
              title: 'Total Hours',
              value: '${project.totalHours} hrs',
              subtitle: 'Total tracked time',
              icon: Icons.access_time_rounded,
              iconColor: AppColors.primary,
              trend: '+12.4 hrs this week',
              isTrendPositive: true,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SummaryCard(
              title: 'Total Revenue',
              value: currencyFormat.format(project.totalRevenue),
              subtitle: 'Billed to date',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.darkDivider, width: 2),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primaryGlow,
        unselectedLabelColor: AppColors.darkTextSecondary,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Kanban Board'),
          Tab(text: 'Analytics'),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProjectModel project) {
    switch (_tabController.index) {
      case 0:
        return SliverToBoxAdapter(child: _buildOverviewContent(project));
      case 1:
        return SliverFillRemaining(
          hasScrollBody: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 40),
            child: KanbanBoardView(project: project),
          ),
        );
      case 2:
        return SliverFillRemaining(
          hasScrollBody: true,
          child: AnalyticsTabView(project: project),
        );
      default:
        return SliverToBoxAdapter(child: _buildOverviewContent(project));
    }
  }

  Widget _buildOverviewContent(ProjectModel project) {
    return Column(
      children: [
        _buildSummaryCards(project),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Obx(() {
                  final controller = Get.find<ProjectController>();
                  final sessions = controller.recentSessions
                      .take(5)
                      .map((session) => SessionItem(
                            title: controller.getSessionTitle(session),
                            date: DateFormat('MMM dd, yyyy')
                                .format(session.startTime),
                            timeRange: session.endTime != null
                                ? '${DateFormat('hh:mm a').format(session.startTime)} - ${DateFormat('hh:mm a').format(session.endTime!)}'
                                : '${DateFormat('hh:mm a').format(session.startTime)} - In Progress',
                            duration: session.durationMinutes / 60.0,
                            icon: Icons.access_time_rounded,
                          ))
                      .toList();
                  return RecentSessionsList(sessions: sessions);
                }),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    WeeklyComparisonCard(
                      thisWeekHours: project.thisWeekHours,
                      lastWeekHours: project.lastWeekHours,
                      weeklyGoal: project.weeklyGoalHours,
                    ),
                    const SizedBox(height: 32),
                    MilestoneCard(
                      progress: project.milestoneProgress,
                      nextMilestone: 'Project Milestone',
                      description:
                          'Reach ${project.weeklyGoalHours.toInt()} total hours to trigger the next billing phase for ${project.clientName}.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
