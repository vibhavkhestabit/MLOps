'use client'; // Tells Next.js this component runs in the user's browser
import { useEffect, useState } from 'react';

export default function Dashboard() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);

  // This runs automatically when the page loads
  useEffect(() => {
    fetch(`${process.env.NEXT_PUBLIC_LARAVEL_API}/tasks`)
      .then((res) => res.json())
      .then((data) => {
        setTasks(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Failed to fetch tasks:", err);
        setLoading(false);
      });
  }, []);

  return (
    <main className="min-h-screen bg-gray-900 p-10 text-white">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold mb-8 text-blue-400">Enterprise Task Dashboard</h1>
        
        {loading ? (
          <p className="text-xl animate-pulse">Connecting to Laravel Backend...</p>
        ) : tasks.length === 0 ? (
          <div className="bg-gray-800 p-6 rounded-lg border border-gray-700">
            <p className="text-gray-400">No tasks found. Use Postman to POST a task to Laravel!</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {tasks.map((task) => (
              <div key={task.id} className="bg-gray-800 p-6 rounded-lg border border-gray-700 shadow-lg transition hover:border-blue-500">
                <div className="flex justify-between items-start mb-4">
                  <h2 className="text-2xl font-semibold">{task.title}</h2>
                  <span className={`px-3 py-1 rounded-full text-xs font-bold uppercase ${
                    task.priority === 'high' ? 'bg-red-500/20 text-red-400' : 
                    task.priority === 'medium' ? 'bg-yellow-500/20 text-yellow-400' : 
                    'bg-green-500/20 text-green-400'
                  }`}>
                    {task.priority}
                  </span>
                </div>
                <p className="text-gray-400 mb-4">{task.description || "No description provided."}</p>
                <div className="flex justify-between text-sm text-gray-500">
                  <span>Status: <strong className="text-white">{task.status}</strong></span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}